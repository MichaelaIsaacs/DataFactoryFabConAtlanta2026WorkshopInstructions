# Lab 1 – Setting up your workspace for Medallion Processing

Set up your Lakehouse and Warehouse for the Medallion architecture with secure boundaries.

In this lab, you will prepare the core data assets used throughout the workshop. You’ll create a Lakehouse for your Landing (Bronze) layer and a Warehouse for the Silver/Gold layers, orchestrate them using a Task Flow, and finish by setting up the metadata database needed for downstream automation.

## Create the Lakehouse and Warehouse using a Task Flow
1. Begin in [https://fabric.microsoft.com](https://fabric.microsoft.com). Please create your own workspace – you should already be provisioned a Fabric capacity for the purpose of this lab.
2. To do so, please click **"New workspace"**. ![alt text](Lab1Photos/1.png)
3. Please name your workspace **"zava_analytics[_yourusername]"** (for the purpose of the lab screenshots, we will just be naming our workspace **zava_analytics**).
4. Please select **Power BI Premium** as your workspace.
5. Please confirm and select via the drop-down that you have access to this capacity **fabcon-gen-westus-p2-0***.
6. Click **apply**.
7. Click **Select a predesignated task flow**, then choose **Medallion** and click **select**.
8. You should now see a templated medallion flow in your UI.
9. Under your **Bronze Data Icon**, select **New Item**.
10. Select the **Lakehouse** item and name it **“ZavaBronzeLakehouse”**. Click **Create**.
11. Once added, return to your workspace.
12. Select from **Silver Data icon** in the medallion flow, then choose **New Item**.
13. Choose a **Warehouse**, name it **“ZavaWarehouse”**, and click **create**.

## Create a Fabric SQL Database to store metadata
Now we will add a Fabric SQL Database to store metadata. This will be useful in our pipelines and orchestration procedures selected later today.
1. At the top of the workspace, click on **New Item**.
2. Search for and select **SQL Database**, then name it **“ZavaMetadataDB”**, and click **Create**. Fabric will provision the SQL Database.
3. Within the "Build your database" scroll, select `T-SQL`.

## Populate the Metadata tables
1. Now let’s populate these tables. Within T-SQL for `ZavaMetadataDB`, click on **new query**.
2. Paste the following metadata SQL script into the query:
```sql
--Please note that query name does not matter here. You can name the query as you see fit.
CREATE TABLE metadata (
    item  VARCHAR(100),
    value INT
);

INSERT INTO metadata (item, value)
VALUES
    ('copyjob',       1),
    ('dataflowgen2',  1),
    ('dbtjob',        1),
    ('semanticmodel', 1);

SELECT * FROM metadata;
```
3. Hit **run**. After hitting run, wait for the script to successfully finish; you should see that it succeeded on the bottom UI (left corner).

---

Your environment is now fully prepared for all future labs.

### By the end of this lab, you have:
- A Lakehouse set up for the Landing (Bronze) layer
- A Warehouse ready for Silver/Gold transformations
- A metadata SQL Database containing Pipeline and Dataflow tracking tables for later pipeline and orchestration work.

You are now ready to begin ingestion and transformation in the next hands-on lab.