# chat_888

Ứng dụng Flutter + Backend Node.js (cấu trúc hoá theo rule_generating_agent.mdc)

## Cấu trúc thư mục
```
project_root/
├── backend/
│   ├── server.js
│   ├── routes/
│   ├── controllers/
│   ├── models/
│   ├── middleware/
│   └── config/
└── frontend/
    ├── lib/
    ├── assets/
    ├── test/ (unit/widget/integration)
    ├── android/ ios/ macos/ linux/ windows/ web/
    └── pubspec.yaml
```

## Cài đặt nhanh
- Backend
```bash
cd backend
npm install
cp .env.example .env
npm run dev
```
- Frontend (Flutter)
```bash
cd ../frontend
flutter pub get
flutter run
```

## API mẫu
- `GET /api/health` → `{ status: "success", message: "OK", data: {} }`

## Chuẩn cấu trúc & ánh xạ
- Mặc định dùng cấu trúc Basic (đơn giản, theo `frontend/lib/{api,models,screens,widgets,utils,theme}`)
- Khi dự án mở rộng, có thể nâng cấp theo ánh xạ (không để song song 2 cấu trúc):
  - `frontend/lib/api` → `frontend/lib/data/datasources`
  - `frontend/lib/models` → `frontend/lib/data/models` (+ `frontend/lib/domain/entities` nếu cần)
  - `frontend/lib/screens` → `frontend/lib/presentation/pages`
  - `frontend/lib/widgets` → `frontend/lib/presentation/widgets`
  - `frontend/lib/utils` → `frontend/lib/core/utils`
  - `frontend/lib/theme` → giữ nguyên hoặc `frontend/lib/core/theme` (chọn 1 kiểu và dùng thống nhất)

## Yêu cầu môi trường
- Node.js >= 18
- Flutter SDK >= 3.22
- PostgreSQL >= 14

Tham khảo chi tiết quy tắc tại `rule_generating_agent.mdc`.
