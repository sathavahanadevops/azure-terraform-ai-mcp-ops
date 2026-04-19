# Azure + Terraform MCP Setup Guide

## Overview
This document provides a generic setup and operating pattern for:
- Azure MCP server (Docker-based, user account auth)
- Terraform MCP server (Docker-based, Terraform Cloud/Enterprise token auth)
- Governance, posture, and cleanup workflows

## Workspace Context
- Workspace path: local repository folder
- MCP config file: `mcp.json`

## MCP Servers

### 1) Azure MCP Server
Configure `mcp.json` to use local Azure CLI login context:
- Docker image: `garrardkitchen/azure-mcp`
- Auth method: mount `%USERPROFILE%\\.azure` into container as read-only
- Input: `azure_subscription_id`

Run pattern:
- `docker run -i --rm -v "$env:USERPROFILE\.azure:/root/.azure-host:ro" -e AZURE_SUBSCRIPTION_ID=<your_subscription_id> garrardkitchen/azure-mcp`

### 2) Terraform MCP Server
Configure `mcp.json` for Terraform Cloud/Enterprise:
- Docker image: `docker.io/hashicorp/terraform-mcp-server:0.5.0`
- Inputs: `address`, `token`, `enabled`

Run pattern:
- `docker run -i --rm -e TFE_ADDRESS=https://app.terraform.io -e TFE_TOKEN=<your_tfe_token> -e ENABLE_TF_OPERATIONS=false docker.io/hashicorp/terraform-mcp-server:0.5.0`

## Recommended Workflow

1. Configure MCP servers in `mcp.json`.
2. Authenticate with Azure CLI (`az login`).
3. Start Azure MCP and Terraform MCP containers.
4. Run discovery and governance queries.
5. Review findings and confirm before any destructive action.
6. Verify post-change state with follow-up checks.

## Useful Commands
- `docker ps --format "table {{.Image}}\t{{.Status}}\t{{.Names}}"`
- `az account show --output json`
- `az account list --all --output json`
- `az vm list -d --query ...`
- `az network public-ip list --query ...`
- `az network public-ip delete ...`
- `az vm delete ... --yes`
- `az network nic delete ...`
- `az disk delete ... --yes`

## Typical Tasks
- List resource groups and governance tags
- Identify unattached network resources
- Detect missing required tags
- Review bastion and VM status
- Summarize recently changed resources
- Compare cloud inventory with Terraform state
- Perform validated cleanup operations

## Generic Posture Checklist
- Resource group count
- Public IP count and unattached list
- Bastion and VM summary
- Tag compliance snapshot

## Security Notes
- Do not store secrets, tokens, or credentials in source-controlled files.
- Keep local-only credentials in ignored local files or environment variables.
- Rotate tokens if they appear in shell history or logs.
- Validate target environment before destructive changes.
