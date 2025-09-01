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

### Backend
```bash
cd backend
npm install
cp .env.example .env
# Chỉnh sửa file .env với thông tin database của bạn
node server.js
```

### Frontend (Flutter)
```bash
cd ../frontend
flutter pub get
flutter run
```

## Cấu hình Database
1. Tạo database PostgreSQL tên `datatest`
2. Copy file `.env.example` thành `.env` trong thư mục backend
3. Cập nhật thông tin database trong file `.env`:
   ```
   DB_USER=postgres
   DB_PASSWORD=your_password
   DB_NAME=datatest
   ```

## Authentication API
- **POST** `/api/auth/register` - Đăng ký user mới
- **POST** `/api/auth/login` - Đăng nhập
- **GET** `/api/auth/profile` - Lấy thông tin user (cần token)

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


## Ghi chú thay đổi (ghi_chu.md)
Repo đã cấu hình tự động cập nhật ghi chú sau mỗi commit qua git hook (post-commit).
- Hooks path: `.githooks/`
- Script: `scripts/update_notes.sh`
- Không cần thao tác thủ công; mỗi commit sẽ được append vào `ghi_chu.md` theo định dạng chuẩn.
- Nếu hook không chạy, xem mục "Khắc phục sự cố" trong `rule_generating_agent.mdc`.
