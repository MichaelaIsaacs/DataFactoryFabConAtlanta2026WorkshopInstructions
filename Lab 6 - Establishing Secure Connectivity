# FabCon Lab 6: Secure Connectivity

In this lab, you will validate how Microsoft Fabric enforces network isolation using **VNet Data Gateway** and **Outbound Access Protection (OAP)**.

---

## Test Your Connection Failure

Now, the lab moderators have secured the connection to protect the sources. Your ADLS Gen2 connection (used back in **Lab 2** for the Copy Job) is now only exposed to certain networks. Let’s confirm this.

1. Go back to your workspace.
2. Find and open your Copy Job that ingests your ADLS Gen2 data. It should be named **zavadataadlscopyjob**.
3. Click **Run** in the upper UI ribbon.
4. Within the monitoring pane, you should see that the Copy Job has **failed**.

---

## Establish VNet for Your ADLS Source

Let’s fix this by connecting to a pre-shared **VNet Data Gateway** to enable secure access.

1. First, confirm you have access to the VNet Data Gateway.
   - Click the **Settings** (gear) icon in the upper-right corner.
   - Select **Manage connections and gateways**.
2. Select the **Virtual Network Data Gateways** tab.
   - You should see a gateway named **DILabVNetGateway** shared with you.
   - If you do not see it, please let your moderator know.
3. Create a new connection using this pre-shared VNet Gateway.
   - Click **New** in the upper-left corner.
4. Select **Virtual Network** and fill in the following information (reference the lab screenshot for the completed example):

   a. **Gateway cluster name**: `DILabVNetGateway`  
   b. **Connection name**: `https://zavarawdata1.dfs.core.windows.net/`  
   c. **Server**: `https://zavarawdata1.dfs.core.windows.net/`  
   d. **Full path**: `/`  
   e. **Authentication**: OAuth 2.0  
      - Click **Edit credentials** and sign in when prompted to validate your account.  
   f. **Privacy level**: Organizational

5. Click **Create**.

---

## Update Your Copy Job to Use the VNet Connection

1. Go back to your Copy Job.
2. Click the **Manage Source** gear in the upper-right corner of the source icon.
3. Click **Edit connection**.
4. Update the connection to use your new VNet connection.
   - Select: `VNET https://zavarawdata1.dfs.core.windows.net/`
   - Click **Update**.
5. Validate the change:
   - Click **Run** in the upper-left corner.
   - Confirm that your Copy Job now runs **successfully**.

---

## Enable Outbound Access Protection (OAP)

Now, let’s enable **Outbound Access Protection (OAP)** to prevent data exfiltration from your workspace.

1. Open **Workspace settings**.
2. Select **Outbound networking**.
3. Scroll down and enable **Block outbound public access**.
   - When prompted, acknowledge the confirmation and click **Yes**.
4. Your Copy Job will now fail again.
   - You can validate this by running the Copy Job and confirming the failure.
5. Scroll down to **Gateway connection policies**.
6. Set **Virtual network and on-prem data gateways** to **Allowed**.
7. Add an allowed gateway:
   - Click **+ Add**.
   - Select your shared VNet Gateway.
8. Click **Save**.

---

## Test & Validate

1. Return to your Copy Job and click **Run**.
2. Confirm that the Copy Job now succeeds.
   - Your data is now securely copied from ADLS into **ZavaADLSbronzelakehouse** using **VNet connectivity** and **Outbound Access Protection**.