# Azure + Terraform MCP Setup (What We Did and How It Was Used)

## Overview
This document captures the setup and usage flow completed in this workspace for:
- Azure MCP server (Docker-based, user account auth)
- Terraform MCP server (Docker-based, Terraform Cloud token auth)
- Azure cleanup and governance tasks executed during the session

## Workspace Context
- Workspace path: `C:\Users\sathavahana\OneDrive\mcp`
- MCP config file: `mcp.json`
- Azure subscription used: `INTEL` (`4798361b-bcde-480f-a551-3c6ea8f38b9f`)

## MCP Servers Configured

### 1) Azure MCP Server
Configured in `mcp.json` to use local Azure CLI login profile (no client secret required):
- Docker image: `garrardkitchen/azure-mcp`
- Auth method: mount `%USERPROFILE%\\.azure` into container as read-only
- Subscription input: `azure_subscription_id`

Effective run pattern:
- `docker run -i --rm -v "$env:USERPROFILE\.azure:/root/.azure-host:ro" -e AZURE_SUBSCRIPTION_ID=<subId> garrardkitchen/azure-mcp`

### 2) Terraform MCP Server
Configured in `mcp.json` with Terraform Cloud inputs:
- Docker image: `docker.io/hashicorp/terraform-mcp-server:0.5.0`
- Inputs: `address`, `token`, `enabled`
- Address used: `https://app.terraform.io`

Effective run pattern:
- `docker run -i --rm -e TFE_ADDRESS=https://app.terraform.io -e TFE_TOKEN=<token> -e ENABLE_TF_OPERATIONS=false docker.io/hashicorp/terraform-mcp-server:0.5.0`

## What Was Done

### A) Azure + Terraform MCP Setup
- Updated `mcp.json` to use Azure account-based login for Azure MCP.
- Removed secret-based Azure MCP inputs (`azure_tenant_id`, `azure_client_id`, `azure_client_secret`) from `mcp.json`.
- Started and validated both MCP server containers.

### B) Subscription Discovery and Posture Checks (INTEL)
- Pulled active subscription details.
- Listed all accessible subscriptions.
- Generated posture metrics:
  - Resource groups, total resources, VM count, Bastion count
  - Public IP inventory and unattached Public IP count
  - Tag compliance snapshot using policy-required tags

### C) Hygiene and Cleanup Performed
- Identified 8 unattached Public IPs in INTEL and deleted them.
- Identified stopped/deallocated VMs in `RG_KGSS_SEA_CORE_SBX`:
  - `AZ-SBX-SEA-DC01`
  - `AZSBXWEB01`
- Checked ownership from tags (`CreatedBy` and contacts).
- Deleted both VMs on request.
- Performed post-VM orphan cleanup:
  - Deleted related NICs
  - Deleted related OS disks
  - Verified no matching leftover Public IPs

## How It Was Used (Operational Pattern)
1. Configure MCP servers in `mcp.json`.
2. Use Azure account login (`az login` context) and mount local `.azure` profile for Azure MCP.
3. Start Azure MCP and Terraform MCP containers.
4. Use Azure queries for discovery/governance.
5. Execute cleanup actions only after explicit confirmation.
6. Verify each destructive action with follow-up checks.

## Useful Commands Used
- `docker ps --format "table {{.Image}}\t{{.Status}}\t{{.Names}}"`
- `az account show --output json`
- `az account list --all --output json`
- `az vm list -d --query ...`
- `az network public-ip list --query ...`
- `az network public-ip delete ...`
- `az vm delete ... --yes`
- `az network nic delete ...`
- `az disk delete ... --yes`

## What We Can Do with This Setup
- Show all resource groups in INTEL with owner and deletion tags.
- List all public IPs in INTEL and mark unattached ones.
- Check whether any VM in INTEL is missing required tags.
- Find all Bastion hosts and their provisioning states.
- Show top 20 resources created in last 7 days.
- Create a report of resources under one environment name.
- Compare what exists in Azure vs what Terraform state tracks.
- Show VMs that are stopped and deallocated.
- Check who owns resources based on tags.
- Remove public IPs not attached to any resource.

## Quick INTEL Subscription Posture Report Template
Use this as a repeatable checklist:
- Resource group count
- Public IP count and unattached list
- Bastion/VM summary
- Tag compliance snapshot

## Session Tasks Completed from the Above List
- Produced INTEL resource group, VM, Bastion, Public IP, and tag compliance posture snapshots.
- Identified and deleted unattached Public IP resources in INTEL.
- Identified stopped/deallocated VMs and checked owner/contact from tags.
- Deleted requested deallocated VMs and cleaned orphan NICs/disks.

## Notes and Security
- Prefer user-login auth for Azure MCP in local environments.
- If a Terraform token was entered directly in shell history, rotate that token in Terraform Cloud and use a fresh one.
- Always verify target subscription before destructive operations.

## Current Outcome Summary
- Azure MCP: configured and validated with account-based auth.
- Terraform MCP: configured and validated with TFE client.
- INTEL subscription cleanup actions requested in this session were completed and verified.
