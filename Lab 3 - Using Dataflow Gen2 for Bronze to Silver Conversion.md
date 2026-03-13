# Lab 3 – Using Dataflow Gen2 for Bronze to Silver Conversion

In this lab, you will build a Dataflow Gen2 that transforms your Zava Bronze data into silver data. There are two ways you can transform your data: one using Copilot to accelerate development, and the other using UI steps.

The Dataflow will write the silver output to a Fabric Data Warehouse.

Your workspace already includes:
- Workspace Identity (enabled in Lab 1)
- Bronze data (via Copy in Lab 2)
- A Fabric Data Warehouse (created in Lab 1)

## Create a New Dataflow Gen2

1. Go to **Initial Process** and select **New Item**. ![alttext](Screenshots/Lab3/1.png)
2. Select **Dataflow Gen2**.![alttext](Screenshots/Lab3/2.png)
3. Name the Dataflow **ZavaDataflowGen2** and select **Create**. ![alttext](Screenshots/Lab3/3.png)
4. Select **Get data from another source** and search for your ADLS bronze Lakehouse named ZavaADLSbronzelakehouse. You may need to search for it. ![alttext](Screenshots/Lab3/4.png)
5. Select all tables and click **Create**. The data should land in the Dataflow interface. ![alttext](Screenshots/Lab3/5.png)
6. Click Create.
7. Verify that the tables have landed in the interface. ![alttext](Screenshots/Lab3/6.png)

At this point, the bronze data has been ingested into the Dataflow Gen2 editor. You will now transform this data from bronze to silver using two approaches: Copilot-based transformations and UI-based transformations.

## Method One – Build the Transformation with Copilot

1. Select **Copilot** from the Dataflow Gen2 authoring sidebar. ![alttext](Screenshots/Lab3/7.png)

### Copilot Transformation: Fix Negative Values

1. In the left query pane, select the retail_order_items table.
2. Select the quantity column.
3. Open Copilot and submit the following prompt:

Replace all negative values in the Quantity column with null. ![alttext](Screenshots/Lab3/8.png)

4. Confirm the transformation is applied successfully.

### Copilot Transformation: Create Revenue Buckets

1. Remaining in the retail_order_items table, select the line_total column.
2. Open **Copilot** and submit the following prompt:

Create a column called RevenueTier with values: Small if LineTotal < 100, Medium if LineTotal between 100 and 1000, Large if greater than 1000. ![alttext](Screenshots/Lab3/9.png)

3. Verify that the RevenueTier column appears in the table.
![alttext](Screenshots/Lab3/10.png)

### AI Transformation: Standardize Phone Numbers

1. In the left query pane, select the retail_customers table.
2. Select the phone column.
3. In the upper ribbon, select **Add column**. ![alttext](Screenshots/Lab3/11.png)
4. Choose **AI Prompt**. ![alttext](Screenshots/Lab3/12.png)

Configure the AI Prompt with the following values:
- **New column name**: Clean_PhoneNumbers
- **Selected column**: phone
- **Prompt text**: Standardize PhoneNumber column into (XXX) XXX-XXXX format and remove non-numeric characters.
- Ensure only the phone column is selected.

5. Select **OK** and confirm the new column is created. ![alttext](Screenshots/Lab3/13.png) ![alttext](Screenshots/Lab3/14.png)

## Method Two – Build Transformations Using the UI

### UI Transformation: Remove Duplicates

1. In the retail_customers table, select the customer_id column.
2. From the Home tab, select **Remove Rows**. 
3. Choose **Remove Duplicates**.![alttext](Screenshots/Lab3/15.png)

### UI Transformation: Enforce Correct Date Data Types

1. In the left query pane, select the retail_inventory table.
2. Select the last_updated column.
3. From the **Transform** tab, select **Data Type** and choose **Date/Time**. ![alttext](Screenshots/Lab3/16.png)
4. With the column still selected, go to **Transform**, then **Date**, and select **Date Only**. ![alttext](Screenshots/Lab3/17.png)
5. You should only see the dates within the column now. ![alttext](Screenshots/Lab3/18.png)

\---

## Transformation #3: Clean Text Fields

1. Go to the **retail customers** table on the left table UI pane
2. Select the **email** column
3. Make sure you are under **Transform** in the upper UI ribbon
4. Click **Format**
5. Select **Trim**, then select **Clean** ![alttext](Screenshots/Lab3/19.png)
6. Your **Applied steps** in the Query Settings (right UI pane) should show that the cleaning and trimming steps occurred ![alttext](Screenshots/Lab3/20.png)


\---

## Configure Destination: Fabric Data Warehouse (Silver Layer Output)

1. Let’s denote these tables as **silver**. 

\- Right-click on the tables in the left UI pane and select **Rename**. ![alttext](Screenshots/Lab3/21.png). 
Add \`silver\_\` to the beginning of each existing table name and add \`\_\` between all spaces.![alttext](Screenshots/Lab3/22.png)

\- Example: rename **retail customers** to **silver\_retail\_customers**.

\- Zoom in on the left UI panel and verify all tables match this naming pattern exactly.

2. In the left UI panel (Named Queries), select **all tables**.

\- With all tables selected, go to the **Home** tab in Dataflow Gen2.

\- Select **Default data destination** and click **Add**. ![alttext](Screenshots/Lab3/23.png)

3. Select your silver warehouse: **ZavaWarehouse**.

4. Select **Bind selected queries**. ![alttext](Screenshots/Lab3/24.png)

5. Select **Save & Run** in the upper-left corner to save and run your Dataflow Gen2.

\- The data will now flow seamlessly from bronze to silver with transformations applied. ![alttext](Screenshots/Lab3/25.png)

6. Go to **ZavaWarehouse** and confirm that the silver data has landed.

\- Verify that the correct table naming is reflected.

\---

## Lab 3 Completion

You have now:

\- Used **Dataflow Gen2** to build silver transformations using both Copilot and UI steps

\- Written curated silver data to a **Fabric Data Warehouse**, ready for silver-to-gold processing

This flow can now be **scheduled**, **templatized**, or **promoted** simply by changing parameter values.