# FabCon Lab 5: End to End Orchestration with Metadata

In this lab, you will build a **medallion orchestration pipeline from scratch** in Microsoft Fabric. The pipeline will orchestrate data processing across the **bronze, silver, and gold layers** using **metadata driven execution**, and will trigger a **Semantic Model refresh** as the final step.

---

## 1. Create & Implement the Master Metadata Orchestration Pipeline

1.  In your Fabric workspace, select **New item** and create a **Pipeline**.
2.  Name the pipeline **Medallion Orchestration Pipeline**.
3.  Select "**Start with a blank canvas**".
4.  Click **If Condition** as the first activity to add to your pipeline.
5.  Click the green **+** button within the **True** section of the If Condition. Select **Copy Job**.
6.  Click on the new embedded Copy Job activity. You will know you have selected the Copy Job when you see a **General** tab and a **Settings** tab.
7.  Under the **General** tab, name it "**Ingest to Bronze**".
8.  Within the **Settings** tab:
    * Setup your connection: select **browse all** and then click **copy job** from the **new sources** section.
    * Ensure the connection from the dropdown says "**Create new connection**".
    * You will need to click **Sign in** to authenticate. Click **Connect**.
    * The **workspace** should be `zava_analytics` and the **copy job** selection should be `zavadatacopyjob`.
9.  Now go back to configuring the **If Condition** – click on the If Condition box. Under the **General** tab, name the If Condition, "**Run Copy Job**".
10. Within the **Activities** section, input the following expression:  
    `@equals(activity('Lookup Metadata').output.value[0].value, 1)`
11. Add the **bronze to silver transformation**, using **Dataflow Gen2**:
    * Click the green arrow at the bottom right of the "**Run Copy Job**" If condition.
    * Select **If Condition**.
    * Within that new If Condition, click the **+** button within the true box and select **Dataflow**.
    * Click on that Dataflow item to configure. Under **General** name the Dataflow "**Prepare Silver**".
    * Within the **Settings** tab, ensure the workspace is `zava_analytics` and the dataflow selected is `ZavaDataFlowGen2`.
    * Configure the **If Condition** for this Dataflow Gen2 item. Under **General**, name it "**Run Dataflow Gen2**".
    * Go to the **Activities** tab and input the expression:  
        `@equals(activity('Lookup Metadata').output.value[1].value, 1)`
12. Add the **bronze to gold processing**, using **dbt job**:
    * Click the green arrow at the bottom of the "**Run Dataflow Gen2**" if condition box.
    * Search for and select **If Condition** as the new activity.
    * Within the **True** section of that new If Condition box, select the **+** button and select **dbt job**.
    * Under the **General** tab, name it "**Transform Gold**".
    * Under the **Settings** tab, select the connection by clicking the drop down and selecting **browse all**.
    * Select **DataBuildTool Job** under the **new sources** section and click **connect**.
    * Ensure the workspace is `zava_analytics`. Select `ZavaDataDbt` as the dbt job.
    * Configure the new **If Condition** for this dbt job. Under the **General** tab, name it "**Run dbt job**".
    * Under the **Activities** tab, input the expression:  
        `@equals(activity('Lookup Metadata').output.value[2].value, 1)`
13. Add the **semantic model**:
    * Click the green arrow at the bottom of the dbt job if condition box.
    * Click **If Condition** as the new activity.
    * Within the true section, click the **+** button and select **Semantic model refresh**.
    * Under **General** name it "**Report from Gold**".
    * Under the **Settings** tab, click **browse all** and select **Power BI Semantic Model** under the new sources section. Click **Connect**.
    * Ensure your workspace is `zava_analytics`, and select your semantic model as `ZavaDataSemanticModel`.
    * Click **select all** for your table selection.
    * Configure the Semantic Model **If Condition**. Within **General**, name it "**Refresh Semantic Model**".
    * Under **Activities**, ensure the expression is:  
        `@equals(activity('Lookup Metadata').output.value[3].value, 1)`

---

## 2. Setup Metadata Driven Execution

1.  Add a **Lookup activity** at the start of the pipeline. Select **Lookup** from the UI activities banner.
2.  Drag it to the left of the bronze ingestion/copy job activity and name it **Lookup Metadata**.
3.  Configure the Lookup to read from the metadata table:
    * Under the **Settings** tab, click on the **Connection** dropdown. Click **browse all**.
    * Search for and select `ZavaMetadataDB`.
    * For the table, within the dropdown, select `dbo.metadata`.
    * Make sure "**first row only**" is **not selected**. Click **enter manually**.
4.  Drag the **green arrow** on the outside edge of the metadata lookup activity towards the first If Condition (Run Copy Job) so that your metadata lookup runs "**on success**".
5.  Go to **Home** and click the purple **save** icon.

---

## 3. Update your Metadata Database

1. Go back to your workspace and find your database for metadata `ZavaMetadataDB`.
2. Click **New Query** on the top UI Panel.
3. Copy and paste the following into the query:
    ```sql
    UPDATE dbo.metadata SET value = 0 WHERE item = 'copyjob';
    UPDATE dbo.metadata SET value = 0 WHERE item = 'dataflow';
    UPDATE dbo.metadata SET value = 0 WHERE item = 'dbtjob';
    UPDATE dbo.metadata SET value = 1 WHERE item = 'semanticmodel';
    ```
4.  Name the query "**update item**" and click **Run**.
5.  Go back to your "**Medallion Orchestration Pipeline**" and click **Run**.

---

## 4. (Optional) Metadata-Driven Pipelines and Audit Run History

1.  **Create Lakehouse**: Go back to your main workspace. Click **New Item** and select **Lakehouse**. Name it `zava_lakehouse`.
2.  **Create Silver Data**: Click **New Item** and select **Notebook**. Name it `01_Create_Silver_Data`. Use the following code and click **Run all**:
    ```python
    data = [
      (1, "US", 100),
      (2, "US", 200),
      (3, "EU", 300),
      (4, "EU", 50)
    ]
    df = spark.createDataFrame(data, ["order_id", "region", "amount"])
    df.write.mode("overwrite").format("delta").saveAsTable("dbo.silver_sales_orders")
    spark.sql("SELECT * FROM dbo.silver_sales_orders").show()
    ```
3.  **Setup Control Plane**: Create a new Notebook named `02_Create_Metadata_And_Audit`. Use the following code to create metadata and audit tables, then click **Run all**:
    ```python
    spark.sql("""CREATE TABLE IF NOT EXISTS dbo.DatasetProcessConfig (
      dataset_name     STRING,
      run_gold         BOOLEAN,
      aggregation_type STRING,
      force_rerun      BOOLEAN,
      active           BOOLEAN
    ) USING DELTA""")

    spark.sql("DELETE FROM dbo.DatasetProcessConfig WHERE dataset_name = 'dbo.silver_sales_orders'")

    spark.sql("""INSERT INTO dbo.DatasetProcessConfig
    (dataset_name, run_gold, aggregation_type, force_rerun, active)
    VALUES ('dbo.silver_sales_orders', true, 'TOTAL_BY_REGION', false, true)""")

    spark.sql("""CREATE TABLE IF NOT EXISTS dbo.DatasetRunAudit (
      pipeline_run_id   STRING,
      pipeline_name     STRING,
      dataset_name      STRING,
      aggregation_type  STRING,
      status            STRING,
      start_time        TIMESTAMP,
      end_time          TIMESTAMP,
      error_message     STRING
    ) USING DELTA""")

    spark.sql("SHOW TABLES IN dbo").show(truncate=False)
    ```
4.  **Gold Aggregation Logic**: Create a Notebook named `03_Gold_Aggregation_Notebook`. Use the code below and click **Run all**:
    ```python
    # These values are injected by the Pipeline "Base parameters"
    dataset_name = "dbo.silver_sales_orders"
    aggregation_type = "TOTAL_BY_REGION"
    pipeline_name = ""
    pipeline_run_id = ""

    from datetime import datetime
    from pyspark.sql import functions as F

    start_time = datetime.utcnow()
    status = "Succeeded"
    error_message = None

    try:
        df = spark.table(dataset_name)
        if aggregation_type == "TOTAL_BY_REGION":
            result = df.groupBy("region").agg(F.sum("amount").alias("total_amount"))
        elif aggregation_type == "AVG_BY_REGION":
            result = df.groupBy("region").agg(F.avg("amount").alias("avg_amount"))
        else:
            raise ValueError(f"Unknown aggregation_type: {aggregation_type}")
        
        result.write.mode("overwrite").format("delta").saveAsTable("dbo.gold_sales_orders")
    except Exception as e:
        status = "Failed"
        error_message = str(e)

    end_time = datetime.utcnow()

    spark.sql(f"""INSERT INTO dbo.DatasetRunAudit
    (pipeline_run_id, pipeline_name, dataset_name, aggregation_type, status, start_time, end_time, error_message)
    VALUES ('{pipeline_run_id}', '{pipeline_name}', '{dataset_name}', '{aggregation_type}', '{status}', 
     TIMESTAMP('{start_time.isoformat()}'), TIMESTAMP('{end_time.isoformat()}'), 
     {("NULL" if error_message is None else "'" + error_message.replace("'", "''") + "'")})""")

    spark.sql("SELECT * FROM dbo.gold_sales_orders").show()
    spark.sql("SELECT dataset_name, aggregation_type, status FROM dbo.DatasetRunAudit").show(truncate=False)
    ```
5.  **Build Metadata Pipeline**:
    * Create a Pipeline named `Metadata_Driven_Pipeline`.
    * Add a **Lookup activity** named `Lookup_Metadata`. Under settings, select connection `zava_lakehouse` and table `dbo.datasetprocessconfig`.
    * Add a **ForEach activity** on success.
    * Inside the ForEach, add an **If Condition activity** with the expression: `@equals(item().run_gold, true)`.
    * In the **True** branch, add the `03_Gold_Aggregation_Notebook` activity and add base parameters.
6.  **Validate**: Save and run the pipeline. Validate the gold output (US 300, EU 350) and audit log in the Lakehouse.