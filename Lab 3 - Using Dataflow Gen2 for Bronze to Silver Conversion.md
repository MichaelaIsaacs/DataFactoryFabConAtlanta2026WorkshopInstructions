# Lab 3 – Using Dataflow Gen2 for Bronze to Silver Conversion

In this lab, you will build a Dataflow Gen2 that transforms your Zava Bronze data into silver data. There are two ways you can transform your data: one using Copilot to accelerate development, and the other using UI steps.

The Dataflow will write the silver output to a Fabric Data Warehouse.

Your workspace already includes:
- Workspace Identity (enabled in Lab 1)
- Bronze data (via Copy in Lab 2)
- A Fabric Data Warehouse (created in Lab 1)

## Create a New Dataflow Gen2

1. Go to Initial Process and select New Item.
2. Select Dataflow Gen2.
3. Name the Dataflow ZavaDataflowGen2 and select Create.
4. Select Get data from another source and search for your ADLS bronze Lakehouse named ZavaADLSbronzelakehouse. You may need to search for it.
5. Select all tables and click Create. The data should land in the Dataflow interface.
6. Click Create.
7. Verify that the tables are visible in the authoring interface.

At this point, the bronze data has been ingested into the Dataflow Gen2 editor. You will now transform this data from bronze to silver using two approaches: Copilot-based transformations and UI-based transformations.

## Method One – Build the Transformation with Copilot

1. Select Copilot from the Dataflow Gen2 authoring sidebar.

### Copilot Transformation: Fix Negative Values

1. In the left query pane, select the retail_order_items table.
2. Select the quantity column.
3. Open Copilot and submit the following prompt:

Replace all negative values in the Quantity column with null.

4. Confirm the transformation is applied successfully.

### Copilot Transformation: Create Revenue Buckets

1. Remaining in the retail_order_items table, select the line_total column.
2. Open Copilot and submit the following prompt:

Create a column called RevenueTier with values: Small if LineTotal < 100, Medium if LineTotal between 100 and 1000, Large if greater than 1000.

3. Verify that the RevenueTier column appears in the table.

### AI Transformation: Standardize Phone Numbers

1. In the left query pane, select the retail_customers table.
2. Select the phone column.
3. In the upper ribbon, select Add column.
4. Choose AI Prompt.

Configure the AI Prompt with the following values:
- New column name: Clean_PhoneNumbers
- Selected column: phone
- Prompt text: Standardize PhoneNumber column into (XXX) XXX-XXXX format and remove non-numeric characters.
- Ensure only the phone column is selected.

5. Select OK and confirm the new column is created.

## Method Two – Build Transformations Using the UI

### UI Transformation: Remove Duplicates

1. In the retail_customers table, select the customer_id column.
2. From the Home tab, select Remove Rows.
3. Choose Remove Duplicates.

### UI Transformation: Enforce Correct Date Data Types

1. In the left query pane, select the retail_inventory table.
2. Select the last_updated column.
3. From the Transform tab, select Data Type and choose Date/Time.
4. With the column still selected, go to Transform, then Date, and select Date Only.
