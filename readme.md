# Class7 – Student Registration API

REST API สำหรับระบบลงทะเบียนเรียน สร้างด้วย **Express.js + PostgreSQL** โครงสร้างแบบ Monolith (repositories / services / controllers / routes)

---

## โครงสร้างโปรเจกต์

```
src/
  app.js
  db.js
  routes/
    ...
  controllers/
    ...
  services/
    ...
  repositories/
    ...
postman/
  collection.json      # Postman Collection (import ได้เลย)
  environment.json     # Postman Environment (import ได้เลย)
init.sql     # SQL สำหรับสร้าง database และ tables
.env.example           # ตัวอย่าง environment variables
```

---

## ขั้นตอนการติดตั้งและรัน

### 1. ติดตั้ง Dependencies

```bash
npm install
```

### 2. ตั้งค่า Database (PostgreSQL)

รัน docker เพื่อเปิด server database

```bash
docker compose up -d
```

### 3. ตั้งค่า Environment Variables

เราจะมีไฟล์ env.example ซึ่งเป็นตัวอย่างของ env ที่ต้องสร้าง 
ให้น้องๆสร้าง .env แล้วนำจาก example ไปใส่

คัดลอก `.env.example` เป็น `.env` แล้วแก้ค่าให้ตรงกับ local setup:

```bash
cp .env.example .env
```

ตัวอย่าง `.env`:

```
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=student_registration
PORT=3000
```

### 4. รัน Server

```bash
# Production
npm start

# Development (auto-reload)
npm run dev
```

Server จะรันที่ `http://localhost:3000`

---
# Backend Assignment: Student-Course-Enrollment API (Express.js + PostgreSQL)

## 1) Tech Stack & Project Rules

## Tech Stack
- Node.js + Express.js
- PostgreSQL (`pg` package)

## โครงสร้างโปรเจกต์ (บังคับ)
```text
src/
  app.js
  db.js
  routes/
    student.route.js
    course.route.js
    enrollment.route.js
  controllers/
    student.controller.js
    course.controller.js
    enrollment.controller.js
  services/
    student.service.js
    course.service.js
    enrollment.service.js
  repositories/
    student.repo.js
    course.repo.js
    enrollment.repo.js
```

## 2) API Base URL

```bash
http://localhost:3000
```

---

## 3) Response Format (มาตรฐานที่คาดหวัง)

## Success
```json
{
  "message": "success",
  "data": {}
}
```

## Error
```json
{
  "message": "error",
  "error": "รายละเอียดสาเหตุ"
}
```

> หมายเหตุ: `data` อาจเป็น object หรือ array ตาม endpoint

---

## 4) Student Module

## Endpoints
- `GET /students`
- `GET /students/:id`
- `POST /students`
- `PUT /students/:id`
- `DELETE /students/:id`

## Validation Rules
- `name`: required, non-empty
- `age`: integer, 15-100
- `major`: one of `CS`, `DSI`, `IT`

## Expected Responses

### GET /students
- **200 OK**
```json
{
  "message": "success",
  "data": [
    { "id": 1, "name": "vavy", "age": 20, "major": "CS" }
  ]
}
```

### GET /students/:id (found)
- **200 OK**
```json
{
  "message": "success",
  "data": { "id": 1, "name": "vavy", "age": 20, "major": "CS" }
}
```

### GET /students/:id (not found)
- **404 Not Found**
```json
{
  "message": "error",
  "error": "student not found"
}
```

### POST /students (valid)
- **201 Created**
```json
{
  "message": "success",
  "data": { "id": 10, "name": "john", "age": 21, "major": "DSI" }
}
```

### POST /students (invalid)
- **400 Bad Request**
```json
{
  "message": "error",
  "error": "major must be one of CS, DSI, IT"
}
```

### PUT /students/:id (valid)
- **200 OK**
```json
{
  "message": "success",
  "data": { "id": 10, "name": "john updated", "age": 22, "major": "CS" }
}
```

### PUT /students/:id (not found)
- **404 Not Found**
```json
{
  "message": "error",
  "error": "student not found"
}
```

### DELETE /students/:id (success)
- **200 OK**
```json
{
  "message": "student deleted",
  "data": null
}
```

---

## 5) Course Module

## Endpoints
- `GET /courses`
- `GET /courses/:course_code`
- `POST /courses`
- `PUT /courses/:course_code`
- `DELETE /courses/:course_code`

## Validation Rules
- `course_code`: required, non-empty, length <= 10
- `title`: required, non-empty
- `credits`: integer, 1-4

## Business Logic เพิ่ม
1. **ห้ามลด credits ถ้ามีนักศึกษาลงท���เบียนอยู่**
   - ตัวอย่าง: เดิม 4 หน่วยกิต ถ้าจะอัปเดตเป็น 3 และมี enrollment อยู่แล้ว => reject
2. **POST course ซ้ำ course_code ต้อง conflict**
   - ถ้า `course_code` มีอยู่แล้ว ให้ตอบ 409

## Expected Responses

### GET /courses
- **200 OK**
```json
{
  "message": "success",
  "data": [
    { "course_code": "CS101", "title": "Introduction to Programming", "credits": 3 }
  ]
}
```

### GET /courses/:course_code (found)
- **200 OK**

### GET /courses/:course_code (not found)
- **404 Not Found**
```json
{
  "message": "error",
  "error": "course not found"
}
```

### POST /courses (valid)
- **201 Created**

### POST /courses (duplicate course_code)
- **409 Conflict**
```json
{
  "message": "error",
  "error": "course_code already exists"
}
```

### PUT /courses/:course_code (valid)
- **200 OK**

### PUT /courses/:course_code (credits reduced while enrolled)
- **400 Bad Request** (หรือ 409 ถ้าทีมตกลงใช้)
```json
{
  "message": "error",
  "error": "cannot reduce credits: students are already enrolled"
}
```

### DELETE /courses/:course_code (success)
- **200 OK**

---

## 6) Enrollment Module

## Endpoints
- `GET /enrollments`
- `GET /enrollments/:enroll_id`
- `POST /enrollments`
- `PUT /enrollments/:enroll_id`
- `DELETE /enrollments/:enroll_id`

## Validation Rules
- `student_id`: required, integer
- `course_code`: required, non-empty
- `grade`: one of `A`, `B`, `C`, `D`, `F`, `W`

## Business Logic เพิ่ม
1. **นักศึกษา 1 คนลงได้ไม่เกิน 3 วิชา**
   - ถ้าเกินแล้ว `POST /enrollments` ต้อง reject

## Expected Responses

### GET /enrollments
- **200 OK**

### GET /enrollments/:enroll_id (found)
- **200 OK**

### GET /enrollments/:enroll_id (not found)
- **404 Not Found**
```json
{
  "message": "error",
  "error": "enrollment not found"
}
```

### POST /enrollments (valid)
- **201 Created**

### POST /enrollments (student already has 3 courses)
- **400 Bad Request** (หรือ 409 ถ้าทีมตกลงใช้)
```json
{
  "message": "error",
  "error": "student cannot enroll more than 3 courses"
}
```

### POST /enrollments (invalid FK)
- **404 Not Found** หรือ **400 Bad Request**
```json
{
  "message": "error",
  "error": "student_id or course_code not found"
}
```

### PUT /enrollments/:enroll_id (valid)
- **200 OK**

### DELETE /enrollments/:enroll_id (success)
- **200 OK**

---

## 7) Suggested HTTP Status Mapping

- `200` = success (GET/PUT/DELETE)
- `201` = created (POST success)
- `400` = validation/business rule failed
- `404` = resource not found
- `409` = conflict (duplicate key / state conflict)

---

## 8) Postman Requirement

ต้องมี 2 ไฟล์:
1. `student-course-enrollment.postman_collection.json`
2. `local.postman_environment.json`

Environment variables:
- `baseUrl`
- `studentId`
- `courseCode`
- `enrollId`

ในแต่ละ request ต้องมี test script ตรวจอย่างน้อย:
- status code
- response keys (`message`, `data` หรือ `error`)
- เงื่อนไขสำคัญ (เช่น enum, range, conflict)

---