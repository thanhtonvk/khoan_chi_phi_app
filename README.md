# Khoản Chi Phí Backend API

## Giới thiệu
Đây là hệ thống quản lý các bảng dữ liệu SQLite sử dụng Flask theo mô hình MVC. Hỗ trợ đầy đủ các API CRUD cho các bảng:
- Account
- MaGiaoKhoan
- TaiSan
- Khau
- MucKhau
- DinhMuc
- QuyetToanGiaoKhoan
- ChiTietGiaoKhoan

## Hướng dẫn chạy ứng dụng

1. Cài đặt Python >= 3.8
2. Cài đặt các thư viện cần thiết:
   ```bash
   pip install flask
   ```
3. Khởi động ứng dụng:
   ```bash
   python app.py
   ```
4. Mặc định API chạy ở địa chỉ: `http://127.0.0.1:5000/`

## Danh sách API và ví dụ sử dụng

### 1. Account
- **GET** `/accounts` — Lấy danh sách tài khoản
- **GET** `/accounts/<userId>` — Lấy chi tiết tài khoản
- **POST** `/accounts` — Thêm tài khoản
- **PUT** `/accounts/<userId>` — Sửa tài khoản
- **DELETE** `/accounts/<userId>` — Xóa tài khoản

**Ví dụ thêm tài khoản:**
```json
POST /accounts
{
  "userId": "u01",
  "userName": "admin",
  "password": "123456",
  "fullName": "Quản trị viên",
  "dob": "1990-01-01",
  "permission": 1
}
```

### 2. MaGiaoKhoan
- **GET** `/magiaokhoans`
- **GET** `/magiaokhoans/<idGiaoKhoan>`
- **POST** `/magiaokhoans`
- **PUT** `/magiaokhoans/<idGiaoKhoan>`
- **DELETE** `/magiaokhoans/<idGiaoKhoan>`

**Ví dụ thêm mã giao khoán:**
```json
POST /magiaokhoans
{
  "idGiaoKhoan": "mgk01",
  "tenVatTuGiaoKhoan": "Xi măng",
  "donViTinh": "kg",
  "donGiaBinhQuanTruoc": 12000,
  "donGiaBinhQuanHienTai": 13000
}
```

### 3. TaiSan
- **GET** `/taisans`
- **GET** `/taisans/<idTaiSan>`
- **POST** `/taisans`
- **PUT** `/taisans/<idTaiSan>`
- **DELETE** `/taisans/<idTaiSan>`

**Ví dụ thêm tài sản:**
```json
POST /taisans
{
  "idTaiSan": "ts01",
  "idGiaoKhoan": "mgk01",
  "tenVatTu": "Xi măng",
  "donViTinh": "kg",
  "soLuong": 100,
  "donGiaBinhQuanTruoc": 12000,
  "donGiaBinhQuanHienTai": 13000,
  "ghiChu": ""
}
```

### 4. Khau
- **GET** `/khaus`
- **GET** `/khaus/<idKhau>`
- **POST** `/khaus`
- **PUT** `/khaus/<idKhau>`
- **DELETE** `/khaus/<idKhau>`

**Ví dụ thêm khẩu:**
```json
POST /khaus
{
  "idKhau": "k01",
  "tenKhau": "Khẩu 1"
}
```

### 5. MucKhau
- **GET** `/muckhaus`
- **GET** `/muckhaus/<idMucKhau>`
- **POST** `/muckhaus`
- **PUT** `/muckhaus/<idMucKhau>`
- **DELETE** `/muckhaus/<idMucKhau>`

**Ví dụ thêm mục khẩu:**
```json
POST /muckhaus
{
  "idMucKhau": "mk01",
  "idKhau": "k01",
  "tenMucKhau": "Mục 1",
  "vietTat": "M1"
}
```

### 6. DinhMuc
- **GET** `/dinhmucs`
- **GET** `/dinhmucs/<idDinhMuc>`
- **POST** `/dinhmucs`
- **PUT** `/dinhmucs/<idDinhMuc>`
- **DELETE** `/dinhmucs/<idDinhMuc>`

**Ví dụ thêm định mức:**
```json
POST /dinhmucs
{
  "idDinhMuc": "dm01",
  "idGiaoKhoan": "mgk01",
  "idMucKhau": "mk01",
  "dinhMuc": 10.5
}
```

### 7. QuyetToanGiaoKhoan
- **GET** `/quyettoans`
- **GET** `/quyettoans/<idQuyetToanGiaoKhoan>`
- **POST** `/quyettoans`
- **PUT** `/quyettoans/<idQuyetToanGiaoKhoan>`
- **DELETE** `/quyettoans/<idQuyetToanGiaoKhoan>`

**Ví dụ thêm quyết toán giao khoán:**
```json
POST /quyettoans
{
  "idQuyetToanGiaoKhoan": "qt01",
  "ngay": "2024-06-01",
  "userId": "u01"
}
```

### 8. ChiTietGiaoKhoan
- **GET** `/chitietgiaokhoans`
- **GET** `/chitietgiaokhoans/<idChiTietGiaoKhoan>`
- **POST** `/chitietgiaokhoans`
- **PUT** `/chitietgiaokhoans/<idChiTietGiaoKhoan>`
- **DELETE** `/chitietgiaokhoans/<idChiTietGiaoKhoan>`

**Ví dụ thêm chi tiết giao khoán:**
```json
POST /chitietgiaokhoans
{
  "idChiTietGiaoKhoan": "ct01",
  "idGiaoKhoan": "mgk01",
  "dinhMucGoc": 10,
  "heSoDieuChinh": 1.2,
  "soLuongKeHoachNgoaiKhoan": 5,
  "soLuongThucHienNgoaiKhoan": 4
}
```

---
## Lưu ý
- Tất cả các API đều nhận và trả về dữ liệu dạng JSON.
- Khi thêm/sửa, cần truyền đầy đủ các trường như ví dụ.
- Để kiểm thử, có thể dùng Postman, curl hoặc bất kỳ công cụ REST client nào. 