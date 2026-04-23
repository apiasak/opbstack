# วิธีติดตั้ง opbstack (Setup Guide)

> **โปรเจกต์**: opbstack — Thai SME One Person Business AI Agent Stack  
> **ผู้สร้าง**: Apipoj Piasak | [data-espresso.com/apipoj](https://data-espresso.com/apipoj)  
> **เวลาที่ใช้**: 5-15 นาที  
> **ระดับความยาก**: ง่าย (ไม่ต้องเขียนโค้ด)  

---

## สิ่งที่ต้องมี (Requirements)

| สิ่งที่ต้องมี | รายละเอียด | ค่าใช้จ่าย |
|---|---|---|
| **Claude Code** (แนะนำมาก) | CLI tool จาก Anthropic ทำงานกับโปรเจกต์ได้โดยตรง | Pro $20/mo, Max $100/$200, หรือ API usage แยก |
| **หรือ Cursor** | Code Editor ที่มี AI ในตัว | ฟรี / Pro $20/เดือน |
| **หรือ ChatGPT Plus** | ใช้ Custom GPTs ได้ | $20/เดือน (~700 บาท) |
| **Git** (optional) | สำหรับติดตั้งแบบ Advanced | ฟรี |

---

## วิธีติดตั้งบน Claude Code (Recommended)

Claude Code เป็นเครื่องมือที่แนะนำมากที่สุด เพราะ:
- ทำงานกับไฟล์ในโปรเจกต์ได้โดยตรง
- รันโค้ดได้ในตัว
- จดจำบริบทของโปรเจกต์คุณได้

### ขั้นตอนที่ 1: ติดตั้ง Node.js (ถ้ายังไม่มี)

```bash
# เช็คว่ามี Node.js หรือยัง
node --version

# ถ้าไม่มี ให้ติดตั้งก่อนที่: https://nodejs.org (เลือก LTS version)
```

### ขั้นตอนที่ 2: ติดตั้ง Claude Code

```bash
# ติดตั้ง Claude Code ผ่าน npm
npm install -g @anthropics/claude-code
```

### ขั้นตอนที่ 3: ล็อกอิน

```bash
# เปิด Claude Code ครั้งแรกจะขอล็อกอิน
claude

# ระบบจะเปิดหน้าเว็บให้ล็อกอินด้วยบัญชี Anthropic/Google
# ล็อกอินเสร็จ กลับมาที่ Terminal
```

> หมายเหตุ: ถ้าเครื่องมี `ANTHROPIC_API_KEY` อยู่ Claude Code จะใช้ API billing แทนสิทธิ์จาก subscription plan

### ขั้นตอนที่ 4: สร้างโปรเจกต์ธุรกิจของคุณ

```bash
# สร้างโฟลเดอร์สำหรับธุรกิจของคุณ
mkdir my-sme-business
cd my-sme-business

# เปิด Claude Code ในโฟลเดอร์นี้
claude
```

### ขั้นตอนที่ 5: เริ่มใช้ Skill!

```
# ตัวอย่างเริ่มต้น — วิเคราะห์ธุรกิจ
/strategist วิเคราะห์ตลาดสำหรับธุรกิจ [ใส่ธุรกิจของคุณ]
```

### สรุปคำสั่งที่ใช้บ่อยใน Claude Code

| คำสั่ง | ทำอะไร |
|---|---|
| `claude` | เปิด Claude Code ในโฟลเดอร์ปัจจุบัน |
| `/strategist [คำสั่ง]` | เรียก Skill นักวางแผน |
| `/brand [คำสั่ง]` | เรียก Skill สร้างแบรนด์ |
| `/build [คำสั่ง]` | เรียก Skill สร้างระบบ |
| `Ctrl+D` | ออกจาก Claude Code |
| `clear` | ล้างหน้าจอ |

---

## วิธีติดตั้งบน Cursor

Cursor เหมาะกับคนที่ต้องการทำเว็บไซต์หรือแอป เพราะเป็น Editor ที่มี AI ในตัว

### ขั้นตอนที่ 1: ดาวน์โหลด Cursor

1. ไปที่ [cursor.com](https://www.cursor.com)
2. คลิก "Download" (มีให้ Mac, Windows, Linux)
3. ติดตั้งเหมือนโปรแกรมทั่วไป

### ขั้นตอนที่ 2: เปิดโปรเจกต์

```
1. เปิด Cursor
2. File → Open Folder (เลือกโฟลเดอร์ธุรกิจของคุณ)
   หรือสร้างใหม่: File → New Window
3. เปิดแท็บ AI Chat: กด Cmd+L (Mac) หรือ Ctrl+L (Windows)
```

### ขั้นตอนที่ 3: ใช้ Skill

```
# ในช่อง AI Chat พิมพ์:
/strategist วิเคราะห์ตลาดสำหรับ [ธุรกิจของคุณ]

# Cursor จะตอบกลับและสามารถ:
# - สร้างไฟล์ใหม่ได้
# - แก้ไขโค้ดได้
# - รันคำสั่งได้
```

### ขั้นตอนที่ 4: สร้างไฟล์ (ถ้าต้องการ)

```
# ถ้า AI สร้างโค้ดหรือเอกสารให้
# Cursor จะแสดง "Apply" button
# กด Apply → ไฟล์จะถูกสร้าง/แก้ไขอัตโนมัติ
```

---

## วิธีติดตั้งบน ChatGPT (Custom GPTs)

ChatGPT เหมาะกับคนที่ใช้อยู่แล้ว ไม่ต้องติดตั้งอะไรเพิ่ม

### ขั้นตอนที่ 1: เปิด ChatGPT Plus

ต้องมีบัญชี ChatGPT Plus ($20/เดือน) ถึงจะสร้าง Custom GPTs ได้

```
1. ไปที่ chatgpt.com
2. ล็อกอินด้วยบัญชี Plus ของคุณ
```

### ขั้นตอนที่ 2: สร้าง Custom GPT สำหรับแต่ละ Skill

```
1. คลิก "Explore GPTs" ใน sidebar
2. คลิก "Create a GPT"
3. ตั้งชื่อ: "opbstack - Strategist"
4. ใส่คำอธิบาย: "นักวางแผนธุรกิจสำหรับผู้ประกอบการไทย"
5. ใส่ Instructions (คำสั่ง) — ดูจากไฟล์ strategist/SKILL.md
6. คลิก "Save" → เลือก "Only me" (หรือ "Anyone with a link")
7. ทำซ้ำขั้นตอนนี้สำหรับทุก Skill (10 ตัว)
```

### ขั้นตอนที่ 3: ใช้งาน

```
1. เปิด ChatGPT
2. คลิกชื่อ Custom GPT ที่ต้องการใน sidebar
   (เช่น "opbstack - Strategist")
3. พิมพ์คำสั่งได้เลย
4. ถ้าอยากเปลี่ยน Skill → คลิก Custom GPT อื่น
```

### ขั้นตอนที่ 4: ใช้แบบไม่ต้องสร้าง Custom GPT (ง่ายกว่า)

```
# วิธีนี้ไม่ต้องสร้าง Custom GPT
# แค่พิมพ์ prompt ระบุ Skill ที่ต้องการ:

"ใช้ skill /strategist: วิเคราะห์ตลาดร้านกาแฟ specialty ในกรุงเทพ"

"ใช้ skill /content: เขียนแคปชั่นขายสินค้า organic"

"ใช้ skill /money: คำนวณต้นทุนเค้ก 1 ปอนด์"
```

---

## วิธีติดตั้งบน Gemini

ใช้ได้เช่นกันผ่านการพิมพ์ prompt:

```
1. ไปที่ gemini.google.com
2. ล็อกอินด้วยบัญชี Google
3. พิมพ์ prompt ระบุ Skill:
   "ใช้ skill /strategist: วิเคราะห์ตลาด..."
```

---

## ตารางเปรียบเทียบเครื่องมือ (Tool Comparison)

| ฟีเจอร์ | Claude Code | Cursor | ChatGPT Plus | Gemini |
|---|---|---|---|---|
| **ความง่ายในการติดตั้ง** | ปานกลาง (ต้องใช้ Terminal) | ง่าย (ดาวน์โหลดแอป) | ง่ายมาก (ใช้บนเว็บ) | ง่ายมาก (ใช้บนเว็บ) |
| **ทำงานกับไฟล์ได้** | ✅ ดีมาก | ✅ ดีมาก | ❌ ไม่ได้ | ❌ ไม่ได้ |
| **รันโค้ดได้** | ✅ ได้ | ✅ ได้ | ❌ ไม่ได้ | ❌ ไม่ได้ |
| **ราคา** | Pro $20 / Max $100-$200 / API usage | ฟรี / $20 | $20/เดือน | ฟรี |
| **เหมาะกับ** | คนทำเว็บ/ระบบ | คนทำเว็บ | คนทั่วไป | คนทั่วไป |
| **Skill Chaining** | ✅ ดีมาก | ✅ ดี | ⚠️ ปานกลาง | ⚠️ ปานกลาง |

---

## การอัปเดต (Updating)

### อัปเดต Claude Code

```bash
# รันคำสั่งนี้เพื่ออัปเดต
npm update -g @anthropics/claude-code

# หรือติดตั้งใหม่
npm install -g @anthropics/claude-code@latest
```

### อัปเดต Cursor

```
1. เปิด Cursor
2. ถ้ามีอัปเดต จะขึ้น notification
3. คลิก "Update" หรือไปที่ Settings → Check for Updates
```

### อัปเดต ChatGPT Custom GPTs

```
1. ไปที่ "Explore GPTs"
2. เลือก Custom GPT ที่สร้างไว้
3. คลิก "Edit"
4. แก้ไข Instructions ตามเวอร์ชั่นใหม่
5. คลิก "Update"
```

---

## ตรวจสอบการติดตั้ง (Verification)

หลังติดตั้งเสร็จ ทดสอบด้วยคำสั่งนี้:

```
/strategist สวัสดี ช่วยแนะนำตัวและบอกว่าคุณช่วยอะไรได้บ้าง
```

ถ้าได้คำตอบที่ดี — แสดงว่าพร้อมใช้งาน! 🎉

---

## ขั้นตอนต่อไป (Next Steps)

1. 📖 อ่าน [`GUIDE.md`](GUIDE.md) — คู่มือการใช้งานฉบับเต็ม
2. 📋 ดู [`AGENTS.md`](AGENTS.md) — รายการ Skill ทั้งหมด
3. 🚀 เริ่มใช้ `/strategist` วางแผนธุรกิจของคุณ!

---

> **Tips**: ถ้าติดปัญหา ลอง restart โปรแกรมหรือเปิดสนทนาใหม่ 80% ของปัญหาจะหายไป! 😄

---

*สร้างด้วย ❤️ โดย Apipoj Piasak | data-espresso.com/apipoj*
