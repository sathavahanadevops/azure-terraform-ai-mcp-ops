# Azure Terraform MCP Operations

Reusable guidance for running Azure and Terraform MCP workflows for discovery, governance checks, and cleanup operations.

## Purpose

This repository provides a generic operating model for:
- Cloud inventory and posture checks
- Tag and governance validation
- Resource hygiene and cleanup workflows
- Terraform state awareness alongside live cloud resources

## MCP Servers

### Azure MCP
- Image: `garrardkitchen/azure-mcp`
- Auth model: local Azure CLI login profile mounted into container
- Target selector: `AZURE_SUBSCRIPTION_ID`

### Terraform MCP
- Image: `docker.io/hashicorp/terraform-mcp-server:0.5.0`
- Backend target: Terraform Cloud/Enterprise via `TFE_ADDRESS`
- Auth model: `TFE_TOKEN`

## Quick Start (PowerShell)

Run each MCP server in a separate terminal.

1. Authenticate and select target scope

```powershell
az login
az account set --subscription <your_subscription_id>
```

2. Start Azure MCP

```powershell
docker run -i --rm -v "$env:USERPROFILE\.azure:/root/.azure-host:ro" -e AZURE_SUBSCRIPTION_ID=<your_subscription_id> garrardkitchen/azure-mcp
```

3. Start Terraform MCP

```powershell
docker run -i --rm -e TFE_ADDRESS=https://app.terraform.io -e TFE_TOKEN=<your_tfe_token> -e ENABLE_TF_OPERATIONS=false docker.io/hashicorp/terraform-mcp-server:0.5.0
```

4. Verify containers

```powershell
docker ps --format "table {{.Image}}\t{{.Status}}\t{{.Names}}"
```

## MCP vs CLI Fallback

Use MCP tools as the default interface when direct MCP tool invocation is available in your client runtime.

### Use MCP (Preferred)
- Structured, tool-first responses for agent workflows
- Better for multi-step automation (discover -> evaluate -> confirm -> execute)
- Consistent schema across repeated operations

### Use Azure CLI Fallback
- Use when MCP servers are running but the chat runtime does not expose callable MCP tool endpoints
- Good for one-off checks and immediate validation in terminal sessions
- Keep subscription scope explicit in each command (for example, `--subscription <id>`)

### Recommended Decision Rule
- If MCP tool calls are available in your client: use MCP
- If MCP calls are not exposed but Azure auth is present: use Azure CLI
- For critical or destructive actions: run detect -> review -> confirm -> execute regardless of interface

## Example Operations

- List resource groups with owner and lifecycle tags
- Identify unattached public IP resources
- Detect resources missing required governance tags
- Inventory bastion and virtual machine states
- Report recent resource activity
- Compare cloud resources with Terraform state
- Review stopped or deallocated virtual machines
- Perform cleanup after explicit confirmation

## Generic Posture Checklist

- Resource group count
- Public IP count and unattached list
- Bastion and VM summary
- Tag compliance snapshot

## Security Notes

- Never commit credentials, tokens, or secret values.
- Keep local-only values in ignored files (for example, `.auto.tfvars` not tracked by git).
- Verify target subscription and environment before destructive actions.
- Use a detect -> review -> confirm -> execute flow for cleanup tasks.