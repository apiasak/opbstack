# setup-opencode.md — ติดตั้ง opbstack บน OpenCode + Model Ark (Legacy Path)

> คู่มือนี้เก็บไว้สำหรับคนที่ยังใช้ **OpenCode** อยู่แล้วร่วมกับ **BytePlus ModelArk Coding Plan** และ **opbstack**
>
> *This guide is kept for existing OpenCode users. As of 2026-04-23, the official OpenCode GitHub repo is archived and points users to Crush for ongoing development.*

> 📌 **สถานะล่าสุด**: OpenCode ยังติดตั้งและใช้งานได้ตามเอกสาร ModelArk integration ของ BytePlus แต่ upstream project เดิมไม่ active แล้ว ถ้าจะเริ่มใหม่วันนี้ ให้พิจารณา Claude Code, OpenClaw, Hermes Agent หรือ Crush แทน

---

## ทำไมบางคนยังใช้ OpenCode + Model Ark?

| | Claude Code | OpenCode + Model Ark |
|---|---|---|
| **ราคา** | Pro $20, Max $100/$200 หรือ API billed separately | OpenCode ฟรี + ModelArk Lite $10 / Pro $50 (list price) |
| **Model** | แค่ Claude | Seed / DeepSeek / GLM / Kimi / GPT-OSS ผ่าน ModelArk |
| **สลับ Model** | ไม่ได้ | **ได้กลาง session** (Plan = แพง, Execute = ถูก) |
| **Open Source** | ปิด | OpenCode เป็น open source แต่ upstream เดิมถูก archive แล้ว |
| **Local Model** | ไม่ได้ | **Ollama, LM Studio** ได้ |
| **ใช้กับ opbstack** | ได้ | **ได้ดีกว่า** (multi-model routing) |

> 💡 **สรุป**: จุดแข็งของ path นี้คือ model flexibility ไม่ใช่ความถูกแบบเดิมอีกต่อไป เพราะราคา ModelArk ปัจจุบันสูงกว่าข้อมูลรุ่นแรกของ repo นี้

---

## สถาปัตยกรรมที่แนะนำ

```
┌─────────────────────────────────────────────────────────────┐
│                    🧠 OPENCODE                               │
│           (Open Source AI Coding Agent)                     │
│   ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐     │
│   │💡 Strat │  │🎨 Brand │  │📢 Market│  │✍️ Contnt│     │
│   │🔧 Build │  │📊 Data  │  │🫶 Serve │  │📋 Admin │     │
│   │💰 Money │  │🌱 Coach │  │         │  │         │     │
│   └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘     │
│        └─────────────┴─────────────┴─────────────┘          │
│                          │                                  │
│              ┌───────────▼───────────┐                      │
│              │   Model Router        │                      │
│              │   (auto switch)       │                      │
│              └───────────┬───────────┘                      │
└──────────────────────────┼──────────────────────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
┌───────▼──────┐  ┌────────▼────────┐  ┌─────▼──────┐
│ 🟣 Model Ark │  │ 🔵 Other Cloud  │  │ 🟢 Local   │
│ (Primary)    │  │ (Fallback)      │  │ (Private)  │
│              │  │                 │  │            │
│ • Seed-Code  │  │ • Claude        │  │ • Ollama   │
│ • GLM-4.7    │  │ • GPT           │  │ • LM Studio│
│ • Kimi-K2.5  │  │ • OpenRouter    │  │ • Qwen     │
│ • GPT-OSS    │  │ • Gemini        │  │ • Llama    │
│              │  │                 │  │            │
│ Lite $10 /   │  │ Pay-per-use     │  │ ฟรี        │
│ Pro $50      │  │ (fallback)      │  │ (hardware) │
└──────────────┘  └─────────────────┘  └────────────┘
```

---

## ขั้นตอนที่ 1: สมัคร BytePlus Model Ark Coding Plan

### 1.1 สมัครบัญชี BytePlus

1. ไปที่ https://console.byteplus.com/
2. สมัครบัญชี (ใช้อีเมลหรือ Google account)
3. เข้าไปที่ **ModelArk** → **Coding Plan**

### 1.2 Subscribe Coding Plan

เลือกแผนที่เหมาะกับคุณ:

| แผน | ราคา | ใช้ได้ |
|---|---|---|
| **Lite** | **$10/เดือน** (~360 บาท) | moderate coding usage |
| **Pro** | **$50/เดือน** (~1,800 บาท) | high-intensity coding usage + ArkClaw included |

> 💡 **แนะนำ**: เริ่มจาก Lite ก่อน ถ้า workload ยังไม่หนักมาก
>
> หมายเหตุ: BytePlus ระบุว่าดีล first-purchase เดิมที่ Lite $5 / Pro $25 ถูก suspend ตั้งแต่ 17 มีนาคม 2026 และ referral campaign อาจให้ส่วนลดเพิ่มชั่วคราวได้

### 1.3 สร้าง API Key

1. ใน ModelArk Console → **API Keys**
2. คลิก **Create API Key**
3. ตั้งชื่อ: `opbstack-opencode`
4. Copy API Key เก็บไว้ (จะใช้ในขั้นตอนที่ 3)

### 1.4 หา Base URL

```
Base URL สำหรับ Coding Plan: https://ark.ap-southeast.bytepluses.com/api/coding/v3
```

> ⚠️ **สำคัญ**: OpenAI-compatible tools เช่น OpenCode ใช้ `/api/coding/v3`
>
> อย่าใช้ `https://ark.ap-southeast.bytepluses.com/api/v3` ตรง ๆ เพราะ BytePlus ระบุว่าจะไม่หักจาก Coding Plan quota และอาจคิดเงินเพิ่มแบบ pay-as-you-go

---

## ขั้นตอนที่ 2: ติดตั้ง OpenCode

> หมายเหตุ: ด้านล่างคือวิธีติดตั้งตามเอกสาร OpenCode/BytePlus ปัจจุบันสำหรับคนที่ยังเลือกใช้ path นี้

### 2.1 ติดตั้ง

```bash
# macOS / Linux
curl -fsSL https://opencode.ai/install | bash

# หรือ Homebrew
brew install anomalyco/tap/opencode

# ตรวจสอบ
opencode --version
```

### 2.2 รัน OpenCode ครั้งแรก

```bash
# ในโปรเจคที่ต้องการใช้
opencode

# หรือระบุ path
opencode -c /path/to/your/business-project
```

จะเห็น TUI (Terminal User Interface) ขึ้นมา

---

## ขั้นตอนที่ 3: เชื่อมต่อ Model Ark กับ OpenCode

### 3.1 วิธีที่ 1: ใช้ Ark Helper (แนะนำ — ง่ายที่สุด)

BytePlus มีเครื่องมือช่วยตั้งค่าอัตโนมัติ:

```bash
# ติดตั้ง Ark Helper
curl -fsSL https://lf3-static.bytednsdoc.com/obj/eden-cn/ylwslo-yrh/ljhwZthlaukjlkulzlp/install.sh | sh

# รัน
ark-helper
```

แล้วทำตามขั้นตอน:
1. เลือก Plan → BytePlus (Overseas)
2. ใส่ API Key ที่สร้างในขั้นตอนที่ 1
3. เลือก Model → `ark-code-latest` หรือ model ตรงที่ต้องการ
4. เลือก Tool → **OpenCode**
5. Ark Helper จะตั้งค่าให้อัตโนมัติ

### 3.2 วิธีที่ 2: ตั้งค่าด้วยตนเอง (Manual)

ใน OpenCode TUI:

```
/connect
```

เลือก **Custom Provider** แล้วใส่:

```
Provider Name: byteplus-plan
Base URL: https://ark.ap-southeast.bytepluses.com/api/coding/v3
API Key: <your-api-key-from-step-1>
```

### 3.3 ตั้งค่าใน config file

สร้างหรือแก้ไข `~/.config/opencode/opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "byteplus-plan/ark-code-latest",
  "provider": {
    "byteplus-plan": {
      "name": "BytePlus",
      "npm": "@ai-sdk/openai-compatible",
      "options": {
        "baseURL": "https://ark.ap-southeast.bytepluses.com/api/coding/v3",
        "apiKey": "YOUR_API_KEY_HERE"
      },
      "models": {
        "ark-code-latest": {
          "name": "ark-code-latest"
        },
        "dola-seed-2.0-pro": {
          "name": "dola-seed-2.0-pro"
        },
        "dola-seed-2.0-lite": {
          "name": "dola-seed-2.0-lite"
        },
        "bytedance-seed-code": {
          "name": "bytedance-seed-code"
        },
        "glm-4.7": {
          "name": "glm-4.7"
        },
        "kimi-k2.5": {
          "name": "kimi-k2.5"
        },
        "gpt-oss-120b": {
          "name": "gpt-oss-120b"
        }
      }
    }
  }
}
```

> หมายเหตุ: docs ล่าสุดของ BytePlus ระบุว่า `deepseek-v3.2` มักต้องเลือกผ่าน console โดยใช้ `ark-code-latest` แทนการ hardcode model name ใน config

---

## ขั้นตอนที่ 4: โหลด opbstack Skills เข้า OpenCode

### 4.1 Clone opbstack

```bash
# Clone repo
git clone --single-branch --depth 1 https://github.com/apiasak/opbstack.git ~/opbstack

# หรือถ้าใช้กับโปรเจคที่มีอยู่
ln -s ~/opbstack ~/.config/opencode/skills/opbstack
```

### 4.2 ตั้งค่า OpenCode ให้รู้จัก Skills

เพิ่มใน `~/.config/opencode/opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "byteplus-plan/ark-code-latest",
  
  "customCommands": {
    "strategist": {
      "description": "นักวางแผนธุรกิจ - Business strategy and planning",
      "prompt": "Read ~/opbstack/core/CLAUDE.md for rules. Then read ~/opbstack/strategist/SKILL.md and act as a Thai business strategist. Respond in Thai with English in parentheses."
    },
    "brand": {
      "description": "นักออกแบบแบรนด์ - Brand identity and design",
      "prompt": "Read ~/opbstack/core/CLAUDE.md for rules. Then read ~/opbstack/brand/SKILL.md and act as a Thai brand designer. Respond in Thai with English in parentheses."
    },
    "build": {
      "description": "นักสร้างระบบ - Build websites and systems",
      "prompt": "Read ~/opbstack/core/CLAUDE.md for rules. Then read ~/opbstack/build/SKILL.md and act as a Thai web/system builder. Respond in Thai with English in parentheses."
    },
    "market": {
      "description": "นักการตลาด - Digital marketing strategy",
      "prompt": "Read ~/opbstack/core/CLAUDE.md for rules. Then read ~/opbstack/market/SKILL.md and act as a Thai digital marketer. Respond in Thai with English in parentheses."
    },
    "content": {
      "description": "นักเขียนคอนเทนต์ - Content creation and copywriting",
      "prompt": "Read ~/opbstack/core/CLAUDE.md for rules. Then read ~/opbstack/content/SKILL.md and act as a Thai content creator. Respond in Thai with English in parentheses."
    },
    "data": {
      "description": "นักวิเคราะห์ข้อมูล - Data analytics and reporting",
      "prompt": "Read ~/opbstack/core/CLAUDE.md for rules. Then read ~/opbstack/data/SKILL.md and act as a Thai data analyst. Respond in Thai with English in parentheses."
    },
    "serve": {
      "description": "นักบริการลูกค้า - Customer success and CRM",
      "prompt": "Read ~/opbstack/core/CLAUDE.md for rules. Then read ~/opbstack/serve/SKILL.md and act as a Thai customer success manager. Respond in Thai with English in parentheses."
    },
    "admin": {
      "description": "ธุรการ - Admin and legal documents",
      "prompt": "Read ~/opbstack/core/CLAUDE.md for rules. Then read ~/opbstack/admin/SKILL.md and act as a Thai business admin. Respond in Thai with English in parentheses."
    },
    "money": {
      "description": "นักการเงิน - Finance and accounting",
      "prompt": "Read ~/opbstack/core/CLAUDE.md for rules. Then read ~/opbstack/money/SKILL.md and act as a Thai finance manager. Respond in Thai with English in parentheses."
    },
    "coach": {
      "description": "โค้ชธุรกิจ - Business coaching and growth",
      "prompt": "Read ~/opbstack/core/CLAUDE.md for rules. Then read ~/opbstack/coach/SKILL.md and act as a Thai business coach. Respond in Thai with English in parentheses."
    }
  }
}
```

### 4.3 ใช้ Skills

ใน OpenCode TUI:

```
/strategist วิเคราะห์ธุรกิจร้านกาแฟของฉัน
/brand ออกแบบโลโก้ใหม่
/market วางแผนการตลาดเดือนหน้า
/content เขียนแคปชั่น 10 อัน
```

---

## ขั้นตอนที่ 5: Model Routing — ใช้ Model ไหนกับ Skill ไหน

### 5.1 แนะนำ Model ตาม Skill

| Skill | แนะนำ Model | เหตุผล |
|---|---|---|
| `/strategist` | `dola-seed-2.0-pro` หรือ `ark-code-latest` | ต้องคิดเชิงกลยุทธ์ วิเคราะห์ลึก |
| `/brand` | `dola-seed-2.0-pro` หรือ `kimi-k2.5` | สร้างสรรค์ ออกแบบ |
| `/build` | `bytedance-seed-code` | Optimized สำหรับ coding |
| `/market` | `glm-4.7` หรือ `ark-code-latest` | ดีกับการวิเคราะห์และ strategy |
| `/content` | `kimi-k2.5` | ดีกับภาษาและการเขียน |
| `/data` | `glm-4.7` หรือ `ark-code-latest` | ดีกับตัวเลขและ logic |
| `/serve` | `dola-seed-2.0-lite` | ง่าย ไม่ต้อง model ใหญ่ |
| `/admin` | `dola-seed-2.0-lite` | เอกสาร ไม่ซับซ้อน |
| `/money` | `glm-4.7` หรือ `ark-code-latest` | คำนวณ ตัวเลข |
| `/coach` | `kimi-k2.5` | ดีกับการสื่อสารและแรงบันดาลใจ |

### 5.2 ตั้งค่า Auto-Routing

เพิ่มใน `opencode.json`:

```json
{
  "routing": {
    "default": "byteplus-plan/dola-seed-2.0-pro",
    "bySkill": {
      "build": "byteplus-plan/bytedance-seed-code",
      "content": "byteplus-plan/kimi-k2.5",
      "data": "byteplus-plan/ark-code-latest",
      "money": "byteplus-plan/ark-code-latest",
      "serve": "byteplus-plan/dola-seed-2.0-lite",
      "admin": "byteplus-plan/dola-seed-2.0-lite",
      "coach": "byteplus-plan/kimi-k2.5"
    }
  }
}
```

---

## ขั้นตอนที่ 6: เพิ่ม Fallback Providers (Optional)

ถ้า Model Ark ล่ม หรือ quota หมด ให้ OpenCode สลับไปใช้ provider อื่นอัตโนมัติ:

### 6.1 เพิ่ม Ollama (Local Model — ฟรี!)

```json
{
  "provider": {
    "ollama": {
      "name": "Ollama (Local)",
      "npm": "@ai-sdk/openai-compatible",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "qwen2.5-coder:7b": {
          "name": "Qwen 2.5 Coder 7B (Local)"
        },
        "qwen2.5-coder:14b": {
          "name": "Qwen 2.5 Coder 14B (Local)"
        }
      }
    }
  }
}
```

ติดตั้ง Ollama:
```bash
curl -fsSL https://ollama.com/install.sh | bash
ollama pull qwen2.5-coder:7b
```

### 6.2 เพิ่ม OpenRouter (Pay-per-use)

```json
{
  "provider": {
    "openrouter": {
      "name": "OpenRouter",
      "models": {
        "anthropic/claude-sonnet-4": {
          "name": "Claude Sonnet 4"
        },
        "openai/gpt-4.1": {
          "name": "GPT 4.1"
        }
      }
    }
  }
}
```

### 6.3 ตั้งค่า Fallback Chain

```json
{
  "fallback": [
    "byteplus-plan/dola-seed-2.0-pro",
    "byteplus-plan/dola-seed-2.0-lite",
    "ollama/qwen2.5-coder:7b",
    "openrouter/anthropic/claude-sonnet-4"
  ]
}
```

---

## ขั้นตอนที่ 7: เติม Context (Business + Project)

### 7.1 กรอก business_context

```bash
# ใน OpenCode TUI
cat ~/opbstack/business_context/TEMPLATE.md

# แล้วกรอกข้อมูล บันทึกเป็น
~/opbstack/business_context/BUSINESS.md
```

### 7.2 บอก OpenCode ให้อ่าน Context ก่อนตอบ

เพิ่มใน `opencode.json`:

```json
{
  "systemPrompt": "Before every response, read ~/opbstack/core/CLAUDE.md for rules. If ~/opbstack/business_context/BUSINESS.md exists, read it to understand the business context. If ~/opbstack/project_context/PROJECT.md exists, read it to understand current project. Respond in Thai primarily with English in parentheses."
}
```

---

## 📋 Cheat Sheet — คำสั่งที่ใช้บ่อย

```bash
# ─── เปิด OpenCode ───
opencode
opencode -c /path/to/project

# ─── ใน OpenCode TUI ───
/models              # เลือก model
/providers           # ดู providers
/connect             # เชื่อมต่อ provider ใหม่
/strategist ...      # ใช้ opbstack skill
/brand ...           # ใช้ opbstack skill
/market ...          # ใช้ opbstack skill

# ─── สลับ Model (กลาง session) ───
/models byteplus-plan/dola-seed-2.0-lite   # เร็ว ถูก
/models byteplus-plan/bytedance-seed-code  # สำหรับ coding
/models byteplus-plan/kimi-k2.5            # สำหรับเขียน
/models ollama/qwen2.5-coder:7b        # local ฟรี

# ─── Mode: Plan vs Execute ───
/plan    # วางแผนก่อนทำ (ไม่แตะไฟล์)
/execute # ลงมือทำทันที

# ─── Sessions ───
/sessions            # ดู sessions
/share               # แชร์ link ให้คนอื่น
```

---

## 💰 ค่าใช้จ่ายรวม (ต่อเดือน)

| รายการ | ราคา |
|---|---|
| **BytePlus Model Ark Coding Plan (Lite)** | **$10 (~360 บาท)** |
| **OpenCode** | **ฟรี (Open Source)** |
| **opbstack** | **ฟรี (Open Source)** |
| **Ollama (Local)** | **ฟรี (ใช้เครื่องตัวเอง)** |
| **รวม (เริ่มต้น)** | **$10/เดือน** |

เปรียบเทียบ:
- Claude Pro = $20/เดือน แต่ได้เฉพาะ Claude
- Claude Max = $100/$200 ต่อเดือน สำหรับ usage สูงกว่า
- path นี้จุดเด่นคือสลับ model ได้ ไม่ใช่ถูกที่สุดเสมอไป

---

## 🆘 Troubleshooting

### OpenCode ไม่เชื่อมต่อ Model Ark

```bash
# ตรวจสอบ API Key
echo $ARK_API_KEY

# ทดสอบ curl
curl https://ark.ap-southeast.bytepluses.com/api/coding/v3/models \
  -H "Authorization: Bearer YOUR_API_KEY"

# ถ้า error → API Key ผิด หรือ Coding Plan ยังไม่ activate
```

### Model ตอบช้า

```bash
# สลับไป Lite model
/models byteplus-plan/dola-seed-2.0-lite

# หรือใช้ Local model
/models ollama/qwen2.5-coder:7b
```

### Coding Plan Quota หมด

```bash
# ใช้ Ollama (local) ไปก่อน
/models ollama/qwen2.5-coder:7b

# หรือเพิ่ม OpenRouter เป็น fallback
# (ต้องมี OpenRouter API Key + เติมเงิน)
```

---

> 📚 **เอกสารอ้างอิง**:
> - OpenCode Docs: https://opencode.ai/docs
> - OpenCode GitHub (archived; moved to Crush): https://github.com/opencode-ai/opencode
> - Crush GitHub: https://github.com/charmbracelet/crush
> - BytePlus ModelArk: https://docs.byteplus.com/en/docs/ModelArk
> - ModelArk Coding Plan Event: https://www.byteplus.com/en/event/coding-plan
> - opbstack: ดู `GUIDE.md` และ `AGENTS.md`
