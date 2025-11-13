# Cloudflare Deployment Setup

This guide covers setting up automated deployments to Cloudflare Pages (Flutter web) and Cloudflare Workers (backend API) via GitHub Actions.

---

## Prerequisites

1. **Cloudflare Account** (Paid Workers Plan)
2. **GitHub Repository** with Actions enabled
3. **Cloudflare API Token** with permissions:
   - Workers Scripts: Edit
   - Workers Routes: Edit
   - Cloudflare Pages: Edit
   - Account Settings: Read

---

## Step 1: Create Cloudflare API Token

1. Go to https://dash.cloudflare.com/profile/api-tokens
2. Click "Create Token"
3. Use "Edit Cloudflare Workers" template
4. Add additional permissions:
   - Account > Cloudflare Pages > Edit
5. Copy the token (you'll only see it once)

---

## Step 2: Get Cloudflare Account ID

1. Go to https://dash.cloudflare.com
2. Click on "Workers & Pages"
3. Your Account ID is displayed in the right sidebar
4. Copy the Account ID

---

## Step 3: Add GitHub Secrets

Add these secrets to your GitHub repository:

```bash
# Via GitHub CLI
gh secret set CLOUDFLARE_API_TOKEN
# Paste your API token when prompted

gh secret set CLOUDFLARE_ACCOUNT_ID
# Paste your Account ID when prompted
```

**Or via GitHub UI:**
1. Go to Settings > Secrets and variables > Actions
2. Click "New repository secret"
3. Add `CLOUDFLARE_API_TOKEN` with your token
4. Add `CLOUDFLARE_ACCOUNT_ID` with your account ID

---

## Step 4: Create Cloudflare Pages Project

1. Go to https://dash.cloudflare.com
2. Click "Workers & Pages" > "Create application" > "Pages"
3. Choose "Direct Upload"
4. Project name: `bookstrack-app`
5. Production branch: `main`
6. **DO NOT** set up automatic deployments (we'll use GitHub Actions)

---

## Step 5: Configure Workers Project

Your Cloudflare Workers code should be in `cloudflare-workers/` directory with:

```
cloudflare-workers/
├── package.json
├── package-lock.json
├── wrangler.toml
├── src/
│   └── index.ts
└── test/
    └── index.test.ts
```

**wrangler.toml example:**

```toml
name = "bookstrack-api"
main = "src/index.ts"
compatibility_date = "2025-01-01"

[env.production]
name = "bookstrack-api"
route = "https://bookstrack-api.workers.dev/*"

[env.preview]
name = "bookstrack-api-preview"
route = "https://preview-*.bookstrack-api.workers.dev/*"

# Environment variables (use GitHub secrets for sensitive values)
[vars]
ENVIRONMENT = "production"

# KV Namespaces
[[kv_namespaces]]
binding = "CACHE"
id = "your-kv-namespace-id"

# Durable Objects
[[durable_objects.bindings]]
name = "SCAN_SESSION"
class_name = "ScanSession"
```

---

## Step 6: Create KV Namespaces (Optional)

For caching API responses:

```bash
# Production
npx wrangler kv:namespace create "CACHE"

# Preview/Development
npx wrangler kv:namespace create "CACHE" --preview
```

Copy the namespace IDs to `wrangler.toml`.

---

## Step 7: Deploy Workflow Triggers

The workflow (`deploy-cloudflare.yml`) triggers on:

1. **Push to main** → Production deployment
2. **Pull request** → Preview deployment
3. **Manual trigger** → `workflow_dispatch`

### Manual Deployment

```bash
# Via GitHub CLI
gh workflow run deploy-cloudflare.yml

# Or via GitHub UI
Actions > Deploy to Cloudflare > Run workflow
```

---

## Deployment Process

### On Push to Main (Production)

1. Build Flutter web app (release mode, CanvasKit renderer)
2. Deploy to Cloudflare Pages: `https://bookstrack.pages.dev`
3. Build Workers backend
4. Deploy to Cloudflare Workers: `https://bookstrack-api.workers.dev`
5. Run health checks
6. Post success comment on commit

### On Pull Request (Preview)

1. Build Flutter web app
2. Deploy to preview URL: `https://<branch>.bookstrack.pages.dev`
3. Build Workers backend
4. Deploy to preview environment: `https://preview-<pr-number>.bookstrack-api.workers.dev`
5. Post comment on PR with preview URLs

---

## Environment Variables

Workers deployment requires these environment variables:

```bash
# Set via GitHub CLI
gh secret set GEMINI_API_KEY
# Your Google AI API key for Gemini 2.0 Flash

gh secret set GOOGLE_BOOKS_API_KEY
# Your Google Books API key
```

**Or add to wrangler.toml (non-sensitive only):**

```toml
[vars]
ENVIRONMENT = "production"
LOG_LEVEL = "info"
```

---

## Cost Optimization

### Cloudflare Pages (Free Tier)
- Unlimited requests
- Unlimited bandwidth
- 500 builds/month (our workflow uses ~60/month)

### Cloudflare Workers (Paid Plan - $5/month)
- 10M requests/month included
- $0.50 per additional 1M requests
- Durable Objects: $0.15 per 1M requests

### Estimated Monthly Cost
- **Pages:** $0 (free tier)
- **Workers:** $5 (base plan)
- **Total:** ~$5/month

### Preview Deployments
- Use Gemini 2.0 Flash (free) instead of Gemini Pro for previews
- Limit preview deployments to 7 days retention
- Automatically clean up old preview deployments

---

## Monitoring & Debugging

### View Deployment Logs

```bash
# Via GitHub Actions
gh run list --workflow=deploy-cloudflare.yml

# View specific run
gh run view <run-id>

# View Workers logs
npx wrangler tail --env production
```

### Health Checks

Production deployment includes automated health checks:

1. **Web App:** `https://bookstrack.pages.dev`
   - Expected: HTTP 200
   - Tests: App loads correctly

2. **Workers API:** `https://bookstrack-api.workers.dev/health`
   - Expected: HTTP 200
   - Response: `{"status": "ok", "version": "1.0.0"}`

### Manual Verification

```bash
# Test Web App
curl -I https://bookstrack.pages.dev

# Test Workers API
curl https://bookstrack-api.workers.dev/health

# Test search endpoint
curl -X POST https://bookstrack-api.workers.dev/api/search \
  -H "Content-Type: application/json" \
  -d '{"query": "Clean Code", "type": "title"}'
```

---

## Rollback Strategy

### Rollback Pages Deployment

1. Go to https://dash.cloudflare.com
2. Click "Workers & Pages" > "bookstrack-app"
3. Click "Deployments" tab
4. Find previous working deployment
5. Click "..." > "Rollback to this deployment"

### Rollback Workers Deployment

```bash
# Deploy previous version
git checkout <previous-commit>
cd cloudflare-workers
npx wrangler deploy --env production
```

Or use GitHub Actions to re-run a previous successful deployment.

---

## Troubleshooting

### Deployment Fails with "API Token Invalid"

1. Verify token has required permissions
2. Check token hasn't expired
3. Regenerate token if needed
4. Update `CLOUDFLARE_API_TOKEN` secret

### Health Check Fails

1. Check Workers logs: `npx wrangler tail`
2. Verify KV namespaces are created
3. Check environment variables are set
4. Test API endpoints manually with curl

### Build Takes Too Long

1. Enable caching in GitHub Actions (already configured)
2. Use `--debug` flag to identify slow steps
3. Optimize Flutter web build (already using CanvasKit)

### Preview Deployment Not Working

1. Verify PR branch naming
2. Check workflow permissions
3. Ensure `GITHUB_TOKEN` has write access

---

## Custom Domain Setup (Optional)

### Add Custom Domain to Pages

1. Go to Cloudflare Pages > bookstrack-app > Custom domains
2. Add your domain (e.g., `app.bookstrack.com`)
3. Add DNS record (automatic if domain is on Cloudflare)

### Add Custom Domain to Workers

1. Add to `wrangler.toml`:

```toml
[env.production]
routes = [
  { pattern = "api.bookstrack.com/*", zone_name = "bookstrack.com" }
]
```

2. Add DNS record:
   - Type: AAAA
   - Name: api
   - Content: 100:: (Cloudflare Workers IPv6)
   - Proxy: Enabled (orange cloud)

---

## Security Best Practices

1. **API Tokens**
   - Use scoped tokens (minimal permissions)
   - Rotate tokens every 90 days
   - Store only in GitHub Secrets

2. **Workers Secrets**
   - Never commit API keys to git
   - Use `wrangler secret put` for sensitive values:

   ```bash
   npx wrangler secret put GEMINI_API_KEY --env production
   ```

3. **Rate Limiting**
   - Implement rate limiting in Workers
   - Use Cloudflare WAF for DDoS protection

4. **CORS**
   - Restrict CORS to your domain only:

   ```typescript
   const corsHeaders = {
     'Access-Control-Allow-Origin': 'https://bookstrack.pages.dev',
     'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
   };
   ```

---

## Next Steps

1. Set up Cloudflare API token
2. Add GitHub secrets
3. Create Pages project
4. Push to main branch → automatic deployment
5. Verify deployments at URLs
6. Set up custom domains (optional)

---

**Last Updated:** November 12, 2025
**Workflow File:** `.github/workflows/deploy-cloudflare.yml`
