# Project Plan: Edge-First Football Dashboard (Infrastructure-First)

## 1. Project Overview
A modern full-stack testbed utilizing **TanStack Start**, **Neon (Postgres)**, and **Cloudflare**. The goal is to demonstrate a high-performance "Edge" architecture using **Cloudflare Hyperdrive** to eliminate database latency bottlenecks and **CodeRabbit/GitHub Actions** for automated quality gates.

---

## 2. Phase 1: The "Plumbing" (CI/CD & Edge Bootstrap)
**Objective:** Establish a "Green Path" from local code to a live Edge environment.

### Tasks:
- [ ] **Project Initialization:**
    - Initialize TanStack Start using the `cloudflare-pages` adapter.
    - Set up `pnpm` workspace and basic project structure.
- [ ] **GitHub Actions Setup:**
    - `ci.yml`: Automated Linting, Type-checking (`tsc`), and Drizzle Schema validation.
    - `deploy.yml`: Integration with Cloudflare Pages for automated "Preview Deployments" on every Pull Request.
- [ ] **Code Quality Automation:**
    - Integrate **CodeRabbit** via GitHub Marketplace.
    - Configure `.coderabbit.yaml` to prioritize Edge-runtime compatibility reviews.
- [ ] **Observability Baseline:**
    - Initialize **Sentry** with the `@sentry/cloudflare` SDK to capture Edge Function errors.

**Deliverables:**
- A functional CI/CD pipeline.
- A "Hello World" TanStack Start app live on a `*.pages.dev` domain.
- Automated PR feedback loop active via CodeRabbit.

---

## 3. Phase 2: The Data Backbone (Neon & Hyperdrive)
**Objective:** Secure and accelerate the data layer using connection pooling at the edge.

### Tasks:
- [ ] **Database Provisioning:**
    - Setup **Neon** project and create `dev` and `prod` branches.
    - Configure **Drizzle ORM** with `drizzle-kit` for migrations.
- [ ] **Cloudflare Hyperdrive Configuration:**
    - Create a Hyperdrive instance via `wrangler hyperdrive create`.
    - Map the Neon connection string to Hyperdrive.
    - Update `wrangler.toml` to expose the Hyperdrive binding.
- [ ] **Schema Definition:**
    - Define initial Drizzle schemas: `leagues`, `teams`, and `matches`.
    - Create a "Connectivity Test" server function to verify Hyperdrive latency vs. direct connection.

**Deliverables:**
- Drizzle schema pushed to Neon.
- Hyperdrive binding active and accessible within TanStack Start server functions.
- Latency metrics visible in function logs.

---

## 4. Phase 3: Data Ingestion & Logic
**Objective:** Populate the infrastructure with real-world European football data.

### Tasks:
- [ ] **API Integration:**
    - Securely store Football API keys in Cloudflare Secrets.
    - Implement a CRON trigger (Cloudflare Workers) or a manual sync script to fetch data from the API (e.g., API-Football).
- [ ] **Edge Fetching Logic:**
    - Build TanStack Start `server functions` to query Neon through Hyperdrive.
    - Implement TanStack Query for client-side caching and state management.
- [ ] **UI Implementation:**
    - Basic Dashboard layout using Tailwind CSS.
    - League/Club switching logic using TanStack Router's search params.

**Deliverables:**
- Live dashboard fetching data from Neon.
- Seamless switching between leagues with zero-latency UI updates via TanStack Query.

---

## 5. Phase 4: Hardening & Monitoring
**Objective:** Ensure the system is production-ready and observable.

### Tasks:
- [ ] **Edge Testing:**
    - Implement **Vitest** for unit tests of utility functions.
    - Setup **Playwright** for E2E testing of the deployed preview URLs.
- [ ] **Monitoring & Performance:**
    - Configure **BetterStack** or **Axiom** for structured logging from the edge.
    - Final audit of Hyperdrive "Cache Hit" rates in the Cloudflare dashboard.

**Deliverables:**
- Final DevOps report (Latency improvements, Build times, Test coverage).
- Fully automated, monitored, and accelerated football statistics platform.

---

## 6. Tech Stack Summary
- **Framework:** TanStack Start (Nitro/Vinxi)
- **Deployment:** Cloudflare Pages (Edge Functions)
- **Database:** Neon (Serverless Postgres)
- **ORM:** Drizzle ORM
- **Acceleration:** Cloudflare Hyperdrive
- **CI/CD:** GitHub Actions + CodeRabbit
- **Testing:** Vitest + Playwright