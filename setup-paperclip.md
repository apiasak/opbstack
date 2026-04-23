# setup-paperclip.md — ติดตั้ง thaismestack บน Paperclip

> คู่มือนี้อธิบายวิธีใช้ **thaismestack** (10 AI Skills สำหรับ Thai SME) ร่วมกับ **Paperclip** (Control Plane สำหรับบริษัท AI)  
> *This guide explains how to deploy thaismestack's 10 AI skills on Paperclip — the control plane for AI companies.*

> 📌 **อัปเดต 2026-04-23:** เอกสาร Paperclip ปัจจุบันเน้น flow แบบ `paperclipai onboard` / `paperclipai run` แล้วไปสร้าง company, goal, และ agent ใน Web UI ก่อน ส่วน built-in adapter keys รุ่นปัจจุบันคือ `claude_local`, `codex_local`, `gemini_local`, `opencode_local`, `cursor`, `openclaw_gateway`, `hermes_local`, `process`, และ `http`

---

## Paperclip คืออะไร? ทำไมถึงเหมาะกับ thaismestack?

**Paperclip** = "ออฟฟิศบริษัท AI" ที่ให้คุณ:
- สร้าง **บริษัท AI** (Company) พร้อม Org Chart
- **จ้างพนักงาน AI** หลายคน (Agents) ให้ทำงานร่วมกัน
- **มอบหมายงาน** (Issues/Tasks) ให้ agent ทำ
- **ตรวจสอบและอนุมัติ** (Governance) ก่อนผลลัพธ์ออกไป
- **ควบคุมงบประมาณ** (Token Budget) ไม่ให้ค่า AI บานปลาย

**thaismestack** = "คู่มือพนักงาน 10 เล่ม" ที่บอกว่า:
- แต่ละตำแหน่ง (**/strategist, /brand, /market, ...**) ทำหน้าที่อะไร
- ทำงานยังไง ตอบแบบไหน มีขั้นตอนอะไรบ้าง
- ตัวอย่างคำสั่งและเทมเพลตที่ใช้ได้ทันที

> **เมื่อรวมกัน**: คุณจะมี **บริษัท AI เต็มรูปแบบ** พร้อมพนักงาน 10 คนที่ถูกฝึกมาสำหรับธุรกิจ SME ไทยโดยเฉพาะ

```
┌──────────────────────────────────────────────────────────────┐
│                    🏢 PAPERCLIP                               │
│                   (Control Plane)                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐        │
│  │💡 Strateg│  │🎨 Brand │  │📢 Market │  │✍️ Content│        │
│  │🔧 Build │  │📊 Data  │  │🫶 Serve │  │📋 Admin  │        │
│  │💰 Money │  │🌱 Coach │  │         │  │         │        │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘        │
│       └─────────────┴─────────────┴─────────────┘             │
│                         │                                    │
│              ┌──────────▼──────────┐                         │
│              │  Governance Layer   │                         │
│              │  (Audit/Approval)   │                         │
│              └─────────────────────┘                         │
└──────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────▼──────────────────────────────┐
│              ⚡ EXECUTION LAYER (Adapters)                    │
│   ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│   │ Claude   │  │ OpenClaw │  │  Hermes  │  │  Shell   │  │
│   │  Code    │  │          │  │  Agent   │  │ Process  │  │
│   └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
│   ← thaismestack SKILL.md ทำงานในแต่ละ adapter นี้        │
└──────────────────────────────────────────────────────────────┘
```

---

## ขั้นตอนที่ 1: ติดตั้ง Paperclip

### 1.1 สิ่งที่ต้องมี (Requirements)

| สิ่งที่ต้องมี | เวอร์ชั่น | หมายเหตุ |
|---|---|---|
| Node.js | 20+ | Quickstart docs ล่าสุดของ Paperclip ใช้ Node.js 20+ |
| pnpm | 9+ | Quickstart docs ล่าสุดอ้างอิง pnpm 9+ |
| npm | 9+ | มาพร้อม Node.js |
| Git | ล่าสุด | สำหรับ clone skills |
| API key ตาม adapter ที่เลือก | — | เช่น `ANTHROPIC_API_KEY` สำหรับ `claude_local` |

### 1.2 ติดตั้ง Paperclip CLI

```bash
# ติดตั้งผ่าน npm (แนะนำ)
npm install -g @paperclipai/cli

# หรือใช้ npx (ไม่ต้องติดตั้ง global)
npx @paperclipai/cli --version

# ตรวจสอบว่าติดตั้งสำเร็จ
npx paperclipai --version
```

### 1.3 Onboard (สร้างบัญชีครั้งแรก)

```bash
# รันคำสั่ง onboard
npx paperclipai onboard --yes

# หรือ one-command bootstrap + run
pnpm paperclipai run
```

ระบบจะถาม:
```
Quickstart (recommended)
Advanced setup
```

หลังจาก onboard แล้ว แนวทางใน docs ปัจจุบันคือ:
1. เปิด UI ที่ `http://localhost:3100`
2. สร้าง company แรก
3. ตั้ง goal
4. สร้าง CEO agent และเลือก adapter
5. ค่อยขยาย org chart เป็น agent อื่น ๆ

> 💡 **คำแนะนำ**: เริ่มจาก `claude_local` ก่อนเพราะเป็น local adapter ที่ docs ครอบคลุมชัดที่สุด แล้วค่อยเพิ่ม `openclaw_gateway` หรือ `hermes_local`

---

## ขั้นตอนที่ 2: โหลด thaismestack Skills เข้า Paperclip

### 2.1 Clone thaismestack Repo

```bash
# Clone repo (หรือ copy จากที่คุณ download มา)
git clone https://github.com/apiasak/thaismestack.git
cd thaismestack

# ดูโครงสร้างที่มี
ls -la
# ผลลัพธ์:
# README.md  AGENTS.md  GUIDE.md  SETUP.md  setup-paperclip.md
# core/  business_context/  project_context/
# strategist/  brand/  build/  market/  content/
# data/  serve/  admin/  money/  coach/
```

### 2.2 โหลด Skills เข้า Paperclip

Paperclip เก็บ skills ที่ `~/.paperclip/skills/` (หรือตามที่ตั้งค่า)

```bash
# สร้างโฟลเดอร์ skills ใน Paperclip (ถ้ายังไม่มี)
mkdir -p ~/.paperclip/skills

# คัดลอกทั้ง 10 skills จาก thaismestack
# (ใช้ชื่อ skill ตามที่ Paperclip รองรับ — ไม่มี "/" นำหน้า)

cp -r thaismestack/strategist ~/.paperclip/skills/thaistrategist
cp -r thaismestack/brand ~/.paperclip/skills/thaibrand
cp -r thaismestack/build ~/.paperclip/skills/thaibuild
cp -r thaismestack/market ~/.paperclip/skills/thaimarket
cp -r thaismestack/content ~/.paperclip/skills/thaicontent
cp -r thaismestack/data ~/.paperclip/skills/thaidata
cp -r thaismestack/serve ~/.paperclip/skills/thaiserve
cp -r thaismestack/admin ~/.paperclip/skills/thaiadmin
cp -r thaismestack/money ~/.paperclip/skills/thaimoney
cp -r thaismestack/coach ~/.paperclip/skills/thaicoach

# คัดลอก context files
cp -r thaismestack/core ~/.paperclip/
cp -r thaismestack/business_context ~/.paperclip/
cp -r thaismestack/project_context ~/.paperclip/

# ตรวจสอบว่าคัดลอกครบ
tree ~/.paperclip/skills/
# ผลลัพธ์ควรมี 10 โฟลเดอร์
```

### 2.3 ตรวจสอบว่า Paperclip เห็น Skills

```bash
# ตรวจสอบว่าโฟลเดอร์ skills ถูก copy แล้ว
ls ~/.paperclip/skills/

# ผลลัพธ์ที่ควรได้ประมาณนี้:
# ✓ thaistrategist  — วางแผนธุรกิจ (Business Planning)
# ✓ thaibrand       — สร้างแบรนด์ (Brand Identity)
# ✓ thaibuild       — สร้างเว็บ/ระบบ (Build & Systems)
# ✓ thaimarket      — การตลาด (Digital Marketing)
# ✓ thaicontent     — คอนเทนต์ (Content Creation)
# ✓ thaidata        — วิเคราะห์ข้อมูล (Data Analytics)
# ✓ thaiserve       — ดูแลลูกค้า (Customer Success)
# ✓ thaiadmin       — ธุรการ (Admin & Legal)
# ✓ thaimoney       — การเงิน (Finance)
# ✓ thaicoach       — พัฒนาตนเอง (Growth Coach)
```

---

## ขั้นตอนที่ 3: สร้าง Agents (พนักงาน AI 10 คน)

### 3.1 สร้าง Agent ทีละคน

ใน docs ปัจจุบัน Paperclip เน้นสร้าง agent ใน Web UI เป็นหลักหลังจาก onboard/run เสร็จ แล้วค่อยใช้ CLI สำหรับ issue, approval, activity และ diagnostics

ถ้าคุณอยากเริ่มแบบง่าย:
1. เปิด `http://localhost:3100`
2. สร้าง company
3. สร้าง CEO agent
4. เพิ่ม agent ตาม role ใน `slowbar-agents.yaml` ด้านล่าง

ถ้าจะใช้ API/automation ต่อภายหลัง ให้ map ค่าพวก `role`, `adapterType`, `adapterConfig`, `reportsTo`, และ `budgetMonthlyCents` ตาม API docs รุ่นปัจจุบัน

```bash
# ตัวอย่าง control-plane CLI ที่ docs ปัจจุบันมีแน่ ๆ
pnpm paperclipai agent list
pnpm paperclipai agent get <agent-id>
```

### 3.2 สร้าง Agent ทั้งหมดผ่าน Config File (แนะนำ)

> หมายเหตุ: YAML ในส่วนนี้เป็น project template สำหรับจัดโครงสร้างทีมและงบประมาณ ไม่ใช่ contract ทางการของ Paperclip CLI/docs รุ่นล่าสุดแบบ 1:1

สร้างไฟล์ `slowbar-agents.yaml`:

```yaml
# slowbar-agents.yaml — Paperclip Agent Configuration
company: Slow Bar Coffee
version: "1.0"

agents:
  # === PHASE 1: วางรากฐาน ===
  - id: strategist
    name: "Ploy-Strategist"
    display_name: "💡 นักวางแผน"
    skill: thaistrategist
    adapter: claude_local
    budget_monthly: 10        # USD/เดือน
    reports_to: owner         # รายงานตัวคุณ
    context_files:
      - core/CLAUDE.md
      - business_context/BUSINESS.md
    description: |
      วิเคราะห์ธุรกิจ วางแผนกลยุทธ์ SWOT คู่แข่ง
      Business planning, strategy, competitive analysis

  - id: brand
    name: "Ploy-Brand"
    display_name: "🎨 นักออกแบบแบรนด์"
    skill: thaibrand
    adapter: claude_local
    budget_monthly: 10
    reports_to: owner
    context_files:
      - core/CLAUDE.md
      - business_context/BUSINESS.md
    description: |
      ออกแบบแบรนด์ โลโก้ สี โทนเสียง แบรนด์สตอรี่
      Brand identity, design, voice & positioning

  # === PHASE 2: สร้างช่องทาง ===
  - id: build
    name: "Ploy-Build"
    display_name: "🔧 นักสร้างระบบ"
    skill: thaibuild
    adapter: claude_local
    budget_monthly: 15
    reports_to: owner
    context_files:
      - core/CLAUDE.md
      - business_context/BUSINESS.md
    description: |
      สร้างเว็บไซต์ LINE OA Landing Page
      Website, systems, LINE Official Account

  # === PHASE 3: ดึงลูกค้า ===
  - id: market
    name: "Ploy-Market"
    display_name: "📢 นักการตลาด"
    skill: thaimarket
    adapter: claude_local
    budget_monthly: 15
    reports_to: owner
    context_files:
      - core/CLAUDE.md
      - business_context/BUSINESS.md
    description: |
      วางแผนการตลาด Facebook TikTok SEO
      Digital marketing strategy & campaigns

  - id: content
    name: "Ploy-Content"
    display_name: "✍️ นักเขียนคอนเทนต์"
    skill: thaicontent
    adapter: claude_local
    budget_monthly: 12
    reports_to: owner
    context_files:
      - core/CLAUDE.md
      - business_context/BUSINESS.md
    description: |
      เขียนแคปชั่น บทความ สคริปต์วิดีโอ
      Content creation, copywriting, video scripts

  # === PHASE 4: ดูแลและเติบโต ===
  - id: data
    name: "Ploy-Data"
    display_name: "📊 นักวิเคราะห์"
    skill: thaidata
    adapter: claude_local
    budget_monthly: 8
    reports_to: owner
    context_files:
      - core/CLAUDE.md
      - business_context/BUSINESS.md
    description: |
      วิเคราะห์ยอดขาย Dashboard รายงาน
      Data analytics, dashboards, reporting

  - id: serve
    name: "Ploy-Serve"
    display_name: "🫶 นักบริการ"
    skill: thaiserve
    adapter: claude_local
    budget_monthly: 8
    reports_to: owner
    context_files:
      - core/CLAUDE.md
      - business_context/BUSINESS.md
    description: |
      ดูแลลูกค้า CRM Loyalty Program
      Customer success, CRM, loyalty programs

  - id: admin
    name: "Ploy-Admin"
    display_name: "📋 ธุรการ"
    skill: thaiadmin
    adapter: claude_local
    budget_monthly: 5
    reports_to: owner
    context_files:
      - core/CLAUDE.md
      - business_context/BUSINESS.md
    description: |
      เอกสาร ใบเสนอราคา สัญญา
      Admin, legal documents, quotations

  - id: money
    name: "Ploy-Money"
    display_name: "💰 นักการเงิน"
    skill: thaimoney
    adapter: claude_local
    budget_monthly: 5
    reports_to: owner
    context_files:
      - core/CLAUDE.md
      - business_context/BUSINESS.md
    description: |
      บัญชี ต้นทุน ภาษี Break-even
      Finance, accounting, tax planning

  - id: coach
    name: "Ploy-Coach"
    display_name: "🌱 โค้ช"
    skill: thaicoach
    adapter: claude_local
    budget_monthly: 5
    reports_to: owner
    context_files:
      - core/CLAUDE.md
      - business_context/BUSINESS.md
    description: |
      Weekly review SOP เป้าหมาย พัฒนาตนเอง
      Continuous improvement, goal setting, SOPs
```

### 3.3 Deploy Agents

```bash
# ในรุ่นปัจจุบัน แนะนำให้ใช้ slowbar-agents.yaml เป็นแม่แบบสำหรับกรอกข้อมูลใน UI
# แล้วตรวจสอบ agents ที่สร้างแล้วผ่าน CLI
pnpm paperclipai agent list

# ผลลัพธ์:
# 💡 Ploy-Strategist   ● Ready  $10/mo
# 🎨 Ploy-Brand        ● Ready  $10/mo
# 🔧 Ploy-Build        ● Ready  $15/mo
# 📢 Ploy-Market       ● Ready  $15/mo
# ✍️ Ploy-Content      ● Ready  $12/mo
# 📊 Ploy-Data         ● Ready  $8/mo
# 🫶 Ploy-Serve        ● Ready  $8/mo
# 📋 Ploy-Admin        ● Ready  $5/mo
# 💰 Ploy-Money        ● Ready  $5/mo
# 🌱 Ploy-Coach        ● Ready  $5/mo
# ─────────────────────────────────
# รวม: $93/เดือน (~3,200 บาท)
```

---

## ขั้นตอนที่ 4: ตั้งค่า Context (สำคัญมาก!)

Context คือ "สมอง" ที่ทำให้ AI รู้จักธุรกิจคุณ ไม่ต้องเล่าใหม่ทุกครั้ง

### 4.1 กรอก business_context

```bash
# เปิด template
nano business_context/TEMPLATE.md

# กรอกข้อมูลธุรกิจของคุณ
# ดูตัวอย่างใน business_context/EXAMPLE.md

# เมื่อกรอกเสร็จ บันทึกเป็น
mv business_context/TEMPLATE.md business_context/BUSINESS.md
```

### 4.2 กรอก project_context (ถ้ามีงานเฉพาะ)

```bash
# เปิด template
nano project_context/TEMPLATE.md

# กรอกข้อมูลโปรเจกต์
# ดูตัวอย่างใน project_context/EXAMPLE.md

# บันทึกเป็น
mv project_context/TEMPLATE.md project_context/PROJECT.md
```

### 4.3 บอก Paperclip ให้โหลด Context

```bash
# Paperclip CLI ปัจจุบันมี context profiles สำหรับ api-base / company-id / auth defaults
pnpm paperclipai context show

# ส่วน business/project context ของ thaismestack แนะนำให้เก็บเป็นไฟล์ใน repo/workspace
# แล้วอ้างใน adapter promptTemplate / instructionsFilePath / working directory ของ agent แต่ละตัว
```

---

## ขั้นตอนที่ 5: มอบหมายงาน (Issue → Agent)

### 5.1 สร้าง Issue

```bash
# วิธีที่ 1: CLI
pnpm paperclipai issue create \
  --title "วางแผนการตลาดเดือนมิถุนายน" \
  --description "ร้าน Slow Bar กำลังจะเปิดขายเมล็ดกาแฟออนไลน์ ต้องการแผนการตลาดเดือนแรก"

# วิธีที่ 2: Dashboard (Web UI)
# ไปที่ local UI → New Issue
```

> หมายเหตุ: CLI reference ปัจจุบันของ Paperclip document `issue create` และ `issue checkout` ชัดเจนที่สุด ถ้า version ที่คุณใช้ไม่รองรับ flag เพิ่มเติมอย่าง `--assign` ให้สร้าง issue ก่อน แล้ว assign/check out ใน UI หรือผ่าน `pnpm paperclipai issue checkout <issue-id> --agent-id <agent-id>`

### 5.2 ดูสถานะงาน

```bash
# รายการ issues ทั้งหมด
pnpm paperclipai issue list --status todo,in_progress

# ผลลัพธ์:
# #42 วางแผนการตลาดเดือนมิถุนายน
#     Assignee: 📢 Ploy-Market
#     Status: 🔄 In Progress
#     Budget used: $2.30 / $15
#     Time: 3m 12s
#     Audit: ⏳ Awaiting review
```

### 5.3 ตรวจสอบและอนุมัติ (Governance)

```bash
# ดูผลลัพธ์ที่ agent ทำ
pnpm paperclipai issue get 42

# approvals แยกเป็น resource ของตัวเองใน CLI ปัจจุบัน
pnpm paperclipai approval list --status pending
pnpm paperclipai approval approve <approval-id>

# หรือส่งกลับไปแก้ (Request Changes)
pnpm paperclipai approval reject <approval-id> --decision-note "เพิ่มงบ Facebook Ads เป็น 8,000 บาท"
```

---

## ขั้นตอนที่ 6: ใช้งานจริง (ตัวอย่าง)

### สถานการณ์: เปิดร้านกาแฟออนไลน์ "Slow Bar"

> ตัวอย่างด้านล่างเขียนในรูปแบบ workflow shorthand เพื่อให้อ่านง่าย ถ้า CLI รุ่นที่ติดตั้งไม่รองรับ `--assign` ให้สร้าง issue ก่อนแล้ว assign ใน UI หรือใช้ `issue checkout`

```bash
# ═══════════════════════════════════════════════════════════════
# STEP 1: วางแผนธุรกิจ (/strategist)
# ═══════════════════════════════════════════════════════════════

pnpm paperclipai issue create \
  --title "วิเคราะห์ธุรกิจและคู่แข่ง" \
  --assign Ploy-Strategist \
  --description "วิเคราะห์ตลาดกาแฟ specialty ออนไลน์ในไทย คู่แข่งคือใคร โอกาสอยู่ตรงไหน"

# ผลลัพธ์ที่ได้:
# - SWOT Analysis
# - รายชื่อ 5 คู่แข่งหลัก พร้อมจุดแข็ง/จุดอ่อน
# - กลุ่มลูกค้าเป้าหมาย (Persona)
# - แผน 90 วัน

# ═══════════════════════════════════════════════════════════════
# STEP 2: สร้างแบรนด์ (/brand)
# ═══════════════════════════════════════════════════════════════

pnpm paperclipai issue create \
  --title "ออกแบบแบรนด์ Slow Bar Online" \
  --assign Ploy-Brand \
  --description "สร้าง brand identity สำหรับช่องทางออนไลน์ ต้องการโทนสี โลโก้ แบรนด์สตอรี่"

# ผลลัพธ์ที่ได้:
# - โทนสี (Earth tone + Deep Green)
# - โลโก้ concept
# - Brand story (เรื่องราวกาแฟไทย)
# - Brand voice guidelines

# ═══════════════════════════════════════════════════════════════
# STEP 3: สร้างเว็บไซต์ (/build)
# ═══════════════════════════════════════════════════════════════

pnpm paperclipai issue create \
  --title "สร้าง Landing Page ขายเมล็ดกาแฟ" \
  --assign Ploy-Build \
  --description "สร้างหน้าเว็บขายเมล็ดกาแฟ 3 สายพันธุ์ + Drip Box ใช้งบน้อยที่สุด"

# ผลลัพธ์ที่ได้:
# - HTML/CSS/JS สำหรับ Landing Page
# - หรือคำแนะนำแพลตฟอร์ม (Carrd, Shopify, etc.)
# - Copy สำหรับหน้าเว็บ

# ═══════════════════════════════════════════════════════════════
# STEP 4: วางแผนการตลาด (/market)
# ═══════════════════════════════════════════════════════════════

pnpm paperclipai issue create \
  --title "แผนการตลาดเปิดตัวออนไลน์" \
  --assign Ploy-Market \
  --description "งบ 5,000 บาท/เดือน เน้น Instagram และ LINE OA เป้าหมาย 50 คนสั่งซื้อเดือนแรก"

# ผลลัพธ์ที่ได้:
# - แผนการตลาดรายเดือน
# - งบประมาณแต่ละช่องทาง
# - กลุ่มเป้าหมายโฆษณา
# - KPI และวิธีวัดผล

# ═══════════════════════════════════════════════════════════════
# STEP 5: สร้างคอนเทนต์ (/content)
# ═══════════════════════════════════════════════════════════════

pnpm paperclipai issue create \
  --title "คอนเทนต์เปิดตัว 10 โพสต์แรก" \
  --assign Ploy-Content \
  --description "สร้างคอนเทนต์ Instagram 10 โพสต์ สไตล์อบอุ่น เล่าเรื่องกาแฟไทย ไม่ aggressive"

# ผลลัพธ์ที่ได้:
# - 10 แคปชั่นพร้อมแฮชแท็ก
# - Content calendar
# - สคริปต์ Reels 3 คลิป

# ═══════════════════════════════════════════════════════════════
# STEP 6: วิเคราะห์ผล (/data)
# ═══════════════════════════════════════════════════════════════

# หลังจากเปิดตัว 2 สัปดาห์ ให้ data agent วิเคราะห์

pnpm paperclipai issue create \
  --title "วิเคราะห์ผลการตลาด 2 สัปดาห์แรก" \
  --assign Ploy-Data \
  --description "ยอดขาย 15,000 บาท ลูกค้า 23 คน วิเคราะห์ว่าอะไรเวิร์ค อะไรต้องปรับ"

# ผลลัพธ์ที่ได้:
# - Dashboard ยอดขาย
# - ช่องทางที่ขายดีที่สุด
# - สินค้าใดขายดี
# - คำแนะนำปรับปรุง
```

---

## ขั้นตอนที่ 7: ใช้ Adapters หลายตัวร่วมกัน

Paperclip รองรับหลาย adapters พร้อมกัน แต่ชื่อ adapter type ปัจจุบันใน docs ใช้รูปแบบ snake_case เช่น `claude_local`, `openclaw_gateway`, `hermes_local`, และ `process`

ตัวอย่างด้านล่างอัปเดตให้ใกล้กับ adapter keys และ config fields ปัจจุบันมากขึ้น:

### 7.1 ตั้งค่า Adapters

```yaml
# slowbar-adapters.yaml
adapters:
  claude-main:
    adapterType: claude_local
    cwd: /ABSOLUTE/PATH/TO/your-business-project
    model: claude-sonnet-4
    env:
      ANTHROPIC_API_KEY: ${ANTHROPIC_API_KEY}
    timeoutSec: 1800
    maxTurnsPerRun: 12

  openclaw-gateway:
    adapterType: openclaw_gateway
    url: http://127.0.0.1:18789
    headers:
      x-openclaw-token: ${OPENCLAW_GATEWAY_TOKEN}
    agentId: slowbar-builder
    sessionKeyStrategy: issue
    timeoutSec: 120

  hermes-main:
    adapterType: hermes_local
    cwd: /ABSOLUTE/PATH/TO/your-business-project
    model: auto
    timeoutSec: 1800

  shell-worker:
    adapterType: process
    command: "python3 /ABSOLUTE/PATH/TO/scripts/admin-worker.py"
    cwd: /ABSOLUTE/PATH/TO/your-business-project
    timeoutSec: 300
```

หมายเหตุสำคัญ:
- `claude_local` คือ local Claude Code adapter ของ Paperclip
- `openclaw_gateway` เป็น gateway integration ไปยัง OpenClaw ไม่ใช่ local CLI adapter แบบเดียวกับ Claude/Codex
- `hermes_local` มีอยู่ใน built-in adapter registry แล้ว แต่ repo Paperclip ยังมี issue เปิดอยู่เรื่อง skill sync และบาง runtime environment

### 7.2 กำหนด Agent ใช้ Adapter ไหน

```yaml
# อัปเดตใน slowbar-agents.yaml
agents:
  - id: strategist
    adapter: claude-main      # ใช้ Claude Code ผ่าน claude_local

  - id: build
    adapter: openclaw-gateway # ใช้ OpenClaw ผ่าน gateway

  - id: data
    adapter: hermes-main      # ใช้ Hermes Local

  - id: admin
    adapter: shell-worker     # ใช้ process adapter
```

### 7.3 สลับ Adapter ตามงาน (Runtime)

```bash
# สั่งให้ agent ใช้ adapter อื่นชั่วคราว
pnpm paperclipai issue create \
  --title "Deploy website" \
  --assign Ploy-Build \
  --description "Deploy website โดยใช้ shell/process worker หรือ adapter ที่เหมาะกับ environment ปัจจุบัน"
```

> ในระบบจริง คุณมักจะเปลี่ยน agent adapter config ใน UI/agent settings มากกว่าผูก adapter ชั่วคราวผ่าน issue flags

---

## ขั้นตอนที่ 8: Monitoring & Governance

### 8.1 ดู Dashboard

```bash
# เปิด UI หลักจาก local instance
# ปกติจะอยู่ที่ http://localhost:3100 หลัง onboard/run

# หรือดึง dashboard summary ผ่าน CLI ปัจจุบัน
pnpm paperclipai dashboard get

# ผลลัพธ์:
# ┌─────────────────────────────────────────┐
# │  🏢 Slow Bar Coffee                     │
# │  งบรวม: $93/เดือน | ใช้ไป: $34.50      │
# │                                         │
# │  📊 Agents: 10/10 พร้อมทำงาน           │
# │  📝 Issues: 3 Active | 7 Done           │
# │  ⏳ Awaiting Review: 1                  │
# │                                         │
# │  💰 Budget Status: ●●●●●●○○○○ 37%      │
# └─────────────────────────────────────────┘
```

### 8.2 Audit Trail

```bash
# ดู activity ผ่าน CLI ปัจจุบัน
pnpm paperclipai activity list --agent-id Ploy-Market

# ผลลัพธ์:
# [2026-06-01 09:15] Ploy-Market สร้างแผนการตลาด
# [2026-06-01 09:23] Ploy-Market สร้าง ad copy 5 ชุด
# [2026-06-01 09:30] ⏳ Awaiting approval (issue #42)
# [2026-06-01 10:00] ✅ Approved by owner
```

### 8.3 Token Budget Alert

```bash
# การแจ้งเตือนงบใน Paperclip รุ่นปัจจุบันถูกจัดการผ่าน config/UI ของ instance/company
# ใช้ dashboard + agent detail เพื่อติดตาม burn rate และ spend ได้ชัดที่สุด
```

---

## 🎯 คำสั่งยอดนิยม (Cheat Sheet)

```bash
# ─── Bootstrap / Instance ───
npx paperclipai onboard --yes
pnpm paperclipai run
pnpm paperclipai doctor
pnpm paperclipai context show

# ─── Issue Management ───
pnpm paperclipai issue list --status todo,in_progress
pnpm paperclipai issue get 42
pnpm paperclipai issue create --title "..." --description "..."
pnpm paperclipai issue update 42 --status in_progress
pnpm paperclipai issue comment 42 --body "..."

# ─── Agent / Approval ───
pnpm paperclipai agent list
pnpm paperclipai agent get <agent-id>
pnpm paperclipai approval list --status pending
pnpm paperclipai approval approve <approval-id>
pnpm paperclipai approval reject <approval-id> --decision-note "..."

# ─── Dashboard / Activity ───
pnpm paperclipai dashboard get
pnpm paperclipai activity list --entity-type issue
```

---

## 🚨 Troubleshooting

### ปัญหา: Paperclip ไม่เห็น Skills

```bash
# ตรวจสอบ path
ls ~/.paperclip/skills/

# ถ้าไม่มี ให้ copy ใหม่
cp -r /path/to/thaismestack/strategist ~/.paperclip/skills/thaistrategist
```

### ปัญหา: Agent ตอบไม่ตรงกับธุรกิจ

```bash
# ตรวจสอบ context profile ปัจจุบัน
pnpm paperclipai context show
```

### ปัญหา: งบบานปลาย

```bash
# ดู spend ผ่าน dashboard และ agent detail
pnpm paperclipai dashboard get
pnpm paperclipai agent get <agent-id>
```

### ปัญหา: Agent ทำงานไม่เสร็จ

```bash
# ดู activity และรายละเอียด issue
pnpm paperclipai activity list --agent-id <agent-id>
pnpm paperclipai issue get 42
pnpm paperclipai issue comment 42 --body "Please retry with a narrower scope."
```

---

## 💡 Tips สำหรับ Thai SME

### 1. เริ่มเล็ก ๆ ก่อน
```bash
# แทนที่จะ deploy 10 agents ทีเดียว
# เริ่มจาก 3 ตัวหลัก ๆ ก่อน

# ในรุ่นปัจจุบัน มักทำผ่าน UI/org chart ก่อน แล้วค่อยเพิ่ม agent ทีละส่วน

# รอ 1-2 สัปดาห์ แล้วเพิ่มตัวอื่น
# เพิ่ม content/build/data ภายหลังเมื่อ workflow ลงตัว
```

### 2. ใช้ Project Context เปลี่ยนตามงาน
```bash
# งาน A: เปิดตัวสินค้าใหม่
cp project_context/PROJECT-launch.md project_context/PROJECT.md

# งาน B: แคมเปญปีใหม่
cp project_context/PROJECT-newyear.md project_context/PROJECT.md
```

### 3. เอา Output จาก Agent หนึ่งไปให้อีก Agent
```bash
# Agent A (Strategist) วางแผนเสร็จ → ส่งให้ Agent B (Market)
pnpm paperclipai issue create \
  --title "ทำตามแผนการตลาดที่ Strategist วางไว้" \
  --description "ดำเนินการตามแผนที่ issue #41 แล้วให้ทีมการตลาดแตกงานต่อ"
```

---

## 📚 ไฟล์ที่เกี่ยวข้อง

| ไฟล์ | หมายถึง |
|---|---|
| `core/CLAUDE.md` | กติกาการทำงานของ AI |
| `core/AGENTS.md` | คู่มือเรียกใช้ skill |
| `business_context/TEMPLATE.md` | คำถามเติมบริบทธุรกิจ |
| `business_context/EXAMPLE.md` | ตัวอย่างร้านกาแฟ "Slow Bar" |
| `project_context/TEMPLATE.md` | คำถามเติมบริบทโปรเจกต์ |
| `project_context/EXAMPLE.md` | ตัวอย่างเปิดขายออนไลน์ |
| `AGENTS.md` | ดัชนี skill ทั้งหมด |
| `GUIDE.md` | คู่มือใช้งานฉบับเต็ม |

---

## 🏁 สรุปขั้นตอน

```
1. ติดตั้ง / bootstrap  →  `npx paperclipai onboard --yes` หรือ `pnpm paperclipai run`
2. เปิด UI             →  `http://localhost:3100`
3. โหลด Skills        →  copy 10 skills ไป ~/.paperclip/skills/
4. สร้าง company + CEO + agents ใน UI
5. ตั้งค่า Context    →  business_context + project_context
6. มอบหมายงาน        →  `pnpm paperclipai issue create`
7. ตรวจสอบผล        →  dashboard + activity
8. ปรับปรุง          →  วนลูป 6-7 ไปเรื่อย ๆ
```

> 💬 **ต้องการความช่วยเหลือเพิ่ม?**  
> ดูคู่มือ Paperclip: https://docs.paperclip.ing  
> ดูคู่มือ thaismestack: `GUIDE.md`  
> ติดต่อ: data-espresso.com/apipoj
