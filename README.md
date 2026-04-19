# azure-terraform-ai-mcp-ops

AI-driven Azure and Terraform MCP operations for posture, governance, and cleanup automation.

## Purpose

This repository is focused on operating Azure and Terraform environments through MCP-enabled workflows.

It is designed for:
- Subscription discovery and posture checks
- Governance and tag compliance analysis
- Resource hygiene and cleanup operations
- Azure to Terraform state awareness

## MCP Servers Used

### Azure MCP
- Image: `garrardkitchen/azure-mcp`
- Auth model: local Azure CLI login profile mounted into container
- Subscription selector: `AZURE_SUBSCRIPTION_ID`

### Terraform MCP
- Image: `docker.io/hashicorp/terraform-mcp-server:0.5.0`
- Backend target: Terraform Cloud/Enterprise via `TFE_ADDRESS`
- Auth model: `TFE_TOKEN`

## Quick Start (PowerShell)

Run each MCP server in a separate terminal.

1. Authenticate Azure and set target subscription

```powershell
az login
az account set --subscription 4798361b-bcde-480f-a551-3c6ea8f38b9f
```

2. Start Azure MCP

```powershell
docker run -i --rm -v "$env:USERPROFILE\.azure:/root/.azure-host:ro" -e AZURE_SUBSCRIPTION_ID=4798361b-bcde-480f-a551-3c6ea8f38b9f garrardkitchen/azure-mcp
```

3. Start Terraform MCP

```powershell
docker run -i --rm -e TFE_ADDRESS=https://app.terraform.io -e TFE_TOKEN=<your_tfe_token> -e ENABLE_TF_OPERATIONS=false docker.io/hashicorp/terraform-mcp-server:0.5.0
```

4. Verify both containers are running

```powershell
docker ps --format "table {{.Image}}\t{{.Status}}\t{{.Names}}"
```

## Core Operations You Can Run

- Show all resource groups in INTEL with owner and deletion tags
- List all public IPs in INTEL and mark unattached ones
- Check whether any VM in INTEL is missing required tags
- Find all Bastion hosts and their provisioning states
- Show top 20 resources created in last 7 days
- Create a report of resources under one environment name
- Compare what exists in Azure versus what Terraform state tracks
- Show VMs in stopped and deallocated state
- Check owner/contact based on tags
- Remove public IPs not attached to any resource

## Quick INTEL Posture Report Checklist

- Resource group count
- Public IP count and unattached list
- Bastion and VM summary
- Tag compliance snapshot

## Session Outcomes Captured

This setup was used to:
- Configure and run Azure MCP with user-based login
- Configure and run Terraform MCP with Terraform Cloud token
- Produce INTEL subscription posture checks
- Identify and delete unattached public IPs
- Identify deallocated VMs, check ownership tags, and perform requested cleanup

## Repo Identity and Publishing

- Suggested GitHub repository name: `azure-terraform-ai-mcp-ops`
- Suggested short description: `AI-driven Azure and Terraform MCP operations for posture, governance, and cleanup automation.`

Suggested GitHub topics:
- `azure`
- `terraform`
- `mcp`
- `ai`
- `devops`
- `cloud-governance`
- `cloud-operations`
- `infrastructure-as-code`
- `azure-cli`
- `terraform-cloud`

## First Commit Message Template

```text
feat: initialize azure-terraform-ai-mcp-ops with Azure and Terraform MCP setup

- configure Azure MCP with user-login auth via mounted Azure CLI profile
- configure Terraform MCP for Terraform Cloud integration
- add MCP operational documentation and posture/cleanup workflow notes
- include reusable guidance for Azure inventory, governance, and hygiene checks
```

## Security Notes

- Do not store long-lived secrets in source-controlled files.
- Rotate Terraform Cloud tokens if they are ever exposed in shell history.
- Verify active subscription before destructive operations.
- For destructive changes, prefer a detect -> review -> confirm -> execute flow.