Create database QlyKhachSan
Go

Use QlyKhachSan
Go
--Create table - Dinh Hoang Son thuc hien
--table khách hàng--
Create table tblKhachHang
(
	sMaKhachHang Nvarchar(10) NOT NULL,
	sTenKhachHang Nvarchar(20) NOT NULL,
	sPhone Nvarchar(20) NOT NULL,
	sEmail Nvarchar(20)
);

Alter table tblKhachHang Add constraint PK_sMaKhachHang primary key(sMaKhachHang);
alter table tblKhachHang drop column iSoLuong;

--Cau 1:
Alter table tblKhachHang add iSoLuong Int Default(0) not null;
Select * from tblKhachHang;

drop trigger trInsertHoaDon;
--Cau 2:
CREATE TRIGGER trInsertHoaDon
ON tblHoaDon
AFTER INSERT
AS
BEGIN
    UPDATE tblKhachHang
    SET iSoLuong = iSoLuong + 2
    FROM tblKhachHang
    INNER JOIN Inserted ON tblKhachHang.sMaKhachHang = Inserted.sMaKhachHang;
END;

--Test
Insert into tblHoaDon(sMaHoaDon, sMaKhachHang, sMaNhanVien, dNgayDatPhong, dNgayTraPhong, sMaPhong)
Values
('HD012', 'MKH01', 'MANV01', '2023-12-15', '2023-12-17', 'P007');

Select * from tblHoaDon, tblKhachHang
Where tblHoaDon.sMaKhachHang = tblKhachHang.sMaKhachHang;


Select * from tblKhachHang;

select *from tblHoaDon;

--Cau 3: a
drop proc sp_ThongTinConNguoi;
Create procedure sp_ThongTinConNguoi
	@sMaKH NVARCHAR(10)
AS
BEGIN
	SELECT K.sTenKhachHang as tenkhachhang, K.iSoLuong as soluong
	FROM tblKhachHang AS K
	WHERE K.sMaKhachHang = @sMaKH
END;

EXEC sp_ThongTinConNguoi @sMaKH = 'MKH10';

--table Nhân viên--
Create table tblNhanVien
(
	sMaNhanVien Nvarchar(10) NOT NULL,
	sTenNhanVien Nvarchar(20) NOT NULL,
	sPhone Nvarchar(20) NOT NULL,
	sDiaChi Nvarchar(30) NOT NULL,
	sEmail Nvarchar(20)
);

Alter table tblNhanVien add constraint PK_sMaNhanVien primary key(sMaNhanVien);

--table Loại phòng--
Create table tblLoaiPhong
(
	sMaLoaiPhong Nvarchar(10) NOT NULL,
	sTenLoaiPhong Nvarchar(20) NOT NULL,
	sMoTa Nvarchar(50)
);

Alter table tblLoaiPhong add constraint PK_sMaLoaiPhong primary key(sMaLoaiPhong);

--table Loại size phòng--
Create table tblSizePhong
(
	sMaSizePhong Nvarchar(10) NOT NULL,
	sTenLoaiPhong Nvarchar(20) NOT NULL,
	sMoTa Nvarchar(50)
);

Alter table tblSizePhong add constraint PK_sMaSizePhong primary key(sMaSizePhong);

--table phòng--
Create table tblBangPhong
(
	sMaPhong Nvarchar(10) NOT NULL,
	sTenPhong Nvarchar(20) NOT NULL,
	sTrangThai Nvarchar(20) NOT NULL,
	sMaLoaiPhong Nvarchar(10) NOT NULL,
	sMaSizePhong Nvarchar(10) NOT NULL,
	fGiaPhong Float NOT NULL
);

Alter table tblBangPhong add constraint PK_sMaPhong primary key(sMaPhong),
Constraint FK_bangphong_loaiphong foreign key(sMaLoaiPhong) references tblLoaiPhong(sMaLoaiPhong),
Constraint FK_bangphong_sizephong foreign key(sMaSizePhong) references tblSizePhong(sMaSizePhong);

--table hóa đơn--
Create table tblHoaDon
(
	sMaHoaDon Nvarchar(10) NOT NULL,
	sMaKhachHang Nvarchar(10) NOT NULL,
	sMaNhanVien Nvarchar(10) NOT NULL,
	dNgayDatPhong Datetime,
	dNgayTraPhong Datetime,
	sMaPhong Nvarchar(10) NOT NULL 
);

Alter table tblHoaDon add constraint PK_sMaHoaDon primary key(sMaHoaDon),
constraint FK_hoadon_khachhang foreign key(sMaKhachHang) references tblKhachHang(sMaKhachHang),
constraint FK_hoadon_nhanvien foreign key(sMaNhanVien) references tblNhanVien(sMaNhanVien),
constraint FK_hoadon_bangphong foreign key(sMaPhong) references tblBangPhong(sMaPhong);

--table chi tiết hóa đơn--
Create table tblChiTietHoaDon
(
	sMaChiTiet Nvarchar(10) NOT NULL,
	sMaHoaDon Nvarchar(10) NOT NULL,
	sMaPhong Nvarchar(10) NOT NULL,
	sLoaiPhong Nvarchar(10),
	sSizePhong Nvarchar(10),
	iSoLuong Int NOT NULL,
	fGiaPhong float,
	fThanhTien float
);

Alter table tblChiTietHoaDon add constraint PK_sMaChiTiet primary key(sMaChiTiet),
constraint FK_chitiet_hoadon foreign key(sMaHoaDon) references tblHoaDon(sMaHoaDon),
constraint FK_chitiet_phong foreign key(sMaPhong) references tblBangPhong(sMaPhong);

--Them du lieu cho bang khach hang - Hoang Anh Thang
INSERT INTO tblKhachHang(sMaKhachHang,sTenKhachHang,sPhone,sEmail)
VALUES  ('MKH01','Nguyen Van Nam','098767676','nguyennam7@gmail.com'),
		('MKH02','Dong Thi Nga','093581834','dongnga4@gmail.com'),
		('MKH03','Doan Manh Hung','09238482','manhhung24@gmail.com'),
		('MKH04','Nguyen Nhu Quynh','098382123','quynhnhu95@gmail.com'),
		('MKH05','Dong Thi Nga','093581834','dongnga4@gmail.com'),
		('MKH06','Hoang Trong Quan','093831144','quanok123@gmail.com'),
		('MKH07','Trinh Thi Thuy','0937722444','trinhthuy4@gmail.com'),
		('MKH08','Nguyen Van Quy','0912424515','quynguyen@gmail.com'),
		('MKH09','Hoang Anh Thang','0963520265','hoangthang@gmail.com'),
		('MKH10','Hoang Thi Thuy Linh','0941224214','htlinh203@gmail.com');

--Them du lieu cho bang nhan vien
INSERT INTO tblNhanVien(sMaNhanVien,sTenNhanVien,sPhone,sEmail,sDiaChi)
VALUES  ('MANV01','Tran Truc Anh','0942812842','trucanh@gmail.com','Ha Noi'),
		('MANV02','Huynh Cong Hieu','0944121289','hieucong@gmail.com','Bac Giang'),
		('MANV03','Nguyen Van Manh','0921324512','vanmanh@gmail.com','Nam Dinh'),
		('MANV04','Ly Anh Duy','0942133155','anhduy@gmail.com','Bac Giang'),
		('MANV05','Nguyen Van Hieu','094567432','hieunguyen@gmail.com','Lang Son'),
		('MANV06','Tran Dinh Hung','091234144','dinhhung24@gmail.com','Hai Phong'),
		('MANV07','Nguyen Truc Mai','0913123775','ntmai24@gmail.com','Nghe An'),
		('MANV08','Phan Cao Hieu','0991312321','pchieu@gmail.com','Thanh Hoa'),
		('MANV09','Nguyen Huyen Phuong','095346242','hphuong@gmail.com','Lao Cai'),
		('MANV10','Dao Van Long','0915214552','dvlong@gmail.com','Hung Yen');

--Them du lieu cho bang Phong
INSERT INTO tblBangPhong (sMaPhong, sTenPhong, sTrangThai, sMaLoaiPhong, sMaSizePhong, fGiaPhong)
VALUES
('P001', 'Phong 101', 'Trong', 'LP001', 'SP001', 100.0),
('P002', 'Phong 102', 'Da Dat', 'LP002', 'SP002', 150.0),
('P003', 'Phong 103', 'Trong', 'LP004', 'SP002', 200.0),
('P004', 'Phong 104', 'Da Dat ', 'LP001', 'SP001', 100.0),
('P005', 'Phong 105', 'Trong', 'LP006', 'SP003', 180.0),
('P006', 'Phong 106', 'Trong', 'LP005', 'SP001', 130.0),
('P007', 'Phong 107', 'Trong', 'LP003', 'SP002', 150.0),
('P008', 'Phong 108', 'Da Dat ', 'LP006', 'SP002', 170.0),
('P009', 'Phong 109', 'Trong', 'LP004', 'SP003', 220.0),
('P010', 'Phong 110', 'Trong', 'LP002', 'SP001', 120.0);

--Du lieu cho loai phong
INSERT INTO tblLoaiPhong (sMaLoaiPhong, sTenLoaiPhong, sMoTa)
VALUES
('LP001', 'Phong Don', 'Phong đon cho mot nguoi.'),
('LP002', 'Phong Doi', 'Phong đoi voi giuong lon.'),
('LP003', 'Phong Gia Đình', 'Phong danh cho gia đinh voi nhieu giuong.'),
('LP004', 'Phong Suite', 'Phong sang trong voi tien nghi cao cap.'),
('LP005', 'Phong Deluxe', 'Phong cao cap voi day du tien ich.'),
('LP006', 'Phong Studio', 'Phong phu hop cho cap đoi.');

--Du lieu cho SizePhong
INSERT INTO tblSizePhong (sMaSizePhong, sTenLoaiPhong, sMoTa)
VALUES
('SP001', 'Loai 1', 'Loai phong kich thuoc nho.'),
('SP002', 'Loai 2', 'Loai phong trung binh.'),
('SP003', 'Loai 3', 'Loai phong lon.');

-- Du lieu bang tblHoaDon
INSERT INTO tblHoaDon (sMaHoaDon, sMaKhachHang, sMaNhanVien, dNgayDatPhong, dNgayTraPhong, sMaPhong)
VALUES
('HD001', 'MKH01', 'MANV01', '2023-10-15', '2023-10-17', 'P001'),
('HD002', 'MKH02', 'MANV02', '2023-10-16', '2023-10-18', 'P004'),
('HD003', 'MKH03', 'MANV03', '2023-10-17', '2023-10-19', 'P005'),
('HD004', 'MKH06', 'MANV05', '2023-10-18', '2023-10-20', 'P007'),
('HD005', 'MKH03', 'MANV04', '2023-10-19', '2023-10-21', 'P002'),
('HD006', 'MKH02', 'MANV08', '2023-10-20', '2023-10-22', 'P006'),
('HD007', 'MKH07', 'MANV02', '2023-10-21', '2023-10-23', 'P007'),
('HD008', 'MKH08', 'MANV09', '2023-10-22', '2023-10-24', 'P009'),
('HD009', 'MKH02', 'MANV10', '2023-10-23', '2023-10-25', 'P006'),
('HD010', 'MKH04', 'MANV01', '2023-10-24', '2023-10-26', 'P003');

-- Du lieu bang tblChiTietHoaDon
INSERT INTO tblChiTietHoaDon (sMaChiTiet, sMaHoaDon, sMaPhong, sLoaiPhong, sSizePhong, iSoLuong, fGiaPhong, fThanhTien)
VALUES
('CT001', 'HD001', 'P001', 'LP001', 'SP001', 1, 100.0, 100.0),
('CT002', 'HD001', 'P002', 'LP002', 'SP002', 1, 150.0, 150.0),
('CT003', 'HD002', 'P003', 'LP003', 'SP002', 2, 200.0, 400.0),
('CT004', 'HD002', 'P004', 'LP001', 'SP001', 1, 100.0, 100.0),
('CT005', 'HD003', 'P005', 'LP002', 'SP003', 1, 180.0, 180.0),
('CT006', 'HD003', 'P006', 'LP003', 'SP001', 1, 130.0, 130.0),
('CT007', 'HD004', 'P007', 'LP002', 'SP002', 1, 150.0, 150.0),
('CT008', 'HD004', 'P008', 'LP001', 'SP002', 1, 170.0, 170.0),
('CT009', 'HD005', 'P009', 'LP003', 'SP003', 1, 220.0, 220.0),
('CT010', 'HD005', 'P010', 'LP002', 'SP001', 1, 120.0, 120.0);

-- Truy vấn dữ liệu - Dinh Hoang Son thuc hien
-- TRUY VẤN TRÊN 1 BẢNG - Dinh Hoang Son thuc hien

-- Tên khách hàng bắt đầu bằng chữ Hoang
Select * 
from tblKhachHang
where sTenKhachHang Like 'Hoang%';

-- Chi tiết hóa đơn có mã hóa đơn là HD002
Select *
from tblChiTietHoaDon
where sMaHoaDon = 'HD002';

-- Hiển thị thông tin về loại phòng có mã LP002, LP003, LP004
Select *
from tblLoaiPhong
where sMaLoaiPhong = 'LP002' or sMaLoaiPhong = 'LP003' or sMaLoaiPhong = 'LP004';

-- Hiển thị thông tin phòng còn trống
Select *
from tblBangPhong
where sTrangThai = 'Trong';

-- Hiển thị thông tin của tất cả nhân viên
Select *
from tblNhanVien

-- TRUY VẤN TRÊN NHIỀU BẢNG - Dinh Hoang Son thuc hien
-- Hiển thị thông tin của hóa đơn và chi tiết hóa đơn đó
Select *
from tblHoaDon, tblChiTietHoaDon
where tblHoaDon.sMaHoaDon = tblChiTietHoaDon.sMaHoaDon;

-- Hiển thị tổng số hóa đơn có của từng hóa đơn
Select tblHoaDon.sMaHoaDon as [Mã hóa đơn], Count(*) as [Tổng số hóa đơn]
from tblHoaDon, tblChiTietHoaDon
where tblHoaDon.sMaHoaDon = tblChiTietHoaDon.sMaHoaDon
Group by tblHoaDon.sMaHoaDon;

-- Đếm số phòng đã đặt và phòng trống
Select B.sTrangThai as [Trạng thái], Count(*) as [Tổng phòng]
from tblBangPhong as B, tblLoaiPhong as L, tblSizePhong as S
where B.sMaLoaiPhong = L.sMaLoaiPhong and B.sMaSizePhong = S.sMaSizePhong
Group by B.sTrangThai;

-- Tính tổng tiền các hóa đơn của khách hàng
Select K.sTenKhachHang as [Tên khách hàng], Sum(C.fThanhTien) as [Thành tiền]
from tblChiTietHoaDon as C, tblHoaDon as H, tblKhachHang as K
where C.sMaHoaDon = H.sMaHoaDon and H.sMaKhachHang = K.sMaKhachHang
Group by C.sMaHoaDon, K.sTenKhachHang;

-- Hiển thị thông tin hóa đơn của phòng có giá phòng >= 180
Select tblBangPhong.sMaPhong as [Mã phòng], tblBangPhong.sTrangThai as [Trạng thái], tblHoaDon.dNgayDatPhong as [Ngày đặt phòng], tblHoaDon.dNgayTraPhong as [Ngày trả phòng]
from tblBangPhong, tblHoaDon
where tblBangPhong.sMaPhong = tblHoaDon.sMaPhong and tblBangPhong.fGiaPhong >= 180;

-- TẠO VIEW HIỆN DỮ LIỆU - Dinh Hoang Son thuc hien
-- 1.View chi tiết hóa đơn
Create view HoadonChiTiet as
Select tblHoaDon.sMaHoaDon as [Mã hóa đơn], tblHoaDon.sMaKhachHang as [Mã khách hàng], tblHoaDon.sMaNhanVien as [Mã nhân viên], tblChiTietHoaDon.sMaChiTiet as [Mã chi tiết], tblChiTietHoaDon.sMaPhong as [Mã phòng], tblChiTietHoaDon.sLoaiPhong as [Loại phòng], tblChiTietHoaDon.sSizePhong as [Size phòng], tblChiTietHoaDon.iSoLuong as [Số lượng], tblChiTietHoaDon.fGiaPhong as [Giá phòng], tblChiTietHoaDon.fThanhTien as [Thành tiền]
from tblHoaDon, tblChiTietHoaDon
where tblHoaDon.sMaHoaDon = tblChiTietHoaDon.sMaHoaDon;

-- 2.View tổng hóa đơn
Create view TongsoHoaDon as
Select tblHoaDon.sMaHoaDon as [Mã hóa đơn], Count(*) as [Tổng số hóa đơn]
from tblHoaDon, tblChiTietHoaDon
where tblHoaDon.sMaHoaDon = tblChiTietHoaDon.sMaHoaDon
Group by tblHoaDon.sMaHoaDon;

-- 3.View đếm số phòng trống/đã đặt
Create view DemSoPhong as
Select B.sTrangThai as [Trạng thái], Count(*) as [Tổng phòng]
from tblBangPhong as B, tblLoaiPhong as L, tblSizePhong as S
where B.sMaLoaiPhong = L.sMaLoaiPhong and B.sMaSizePhong = S.sMaSizePhong
Group by B.sTrangThai;

-- 4.View tổng tiền hóa đơn
Create view Tongtienhoadon as
Select K.sTenKhachHang as [Tên khách hàng], Sum(C.fThanhTien) as [Thành tiền]
from tblChiTietHoaDon as C, tblHoaDon as H, tblKhachHang as K
where C.sMaHoaDon = H.sMaHoaDon and H.sMaKhachHang = K.sMaKhachHang
Group by C.sMaHoaDon, K.sTenKhachHang;

-- 5.View hiện thông tin hóa đơn phòng có giá >= 180
Create view GiaPhongTren180 as
Select tblBangPhong.sMaPhong as [Mã phòng], tblBangPhong.sTrangThai as [Trạng thái], tblHoaDon.dNgayDatPhong as [Ngày đặt phòng], tblHoaDon.dNgayTraPhong as [Ngày trả phòng]
from tblBangPhong, tblHoaDon
where tblBangPhong.sMaPhong = tblHoaDon.sMaPhong and tblBangPhong.fGiaPhong >= 180;

-- 6.View hiện thông tin nhân viên có địa chỉ là Ha Noi
Create view NhanVienHaNoi as
Select sMaNhanVien as [Mã nhân viên], sTenNhanVien as [Tên nhân viên], sPhone as [Phone], sDiaChi as [Địa chỉ], sEmail as [Email] 
from tblNhanVien
where sDiaChi = 'Ha Noi';

-- 7.View sắp xếp thành tiền của hóa đơn theo thứ tự tăng dần
Create view ThanhtienHoaDonTangDan as
Select tblHoaDon.sMaHoaDon as[Mã hóa đơn], Sum(tblChiTietHoaDon.fThanhTien) as [Thành tiền]
from tblHoaDon, tblChiTietHoaDon
where tblHoaDon.sMaHoaDon = tblChiTietHoaDon.sMaHoaDon
Group by tblHoaDon.sMaHoaDon
Order by 2
OFFSET 0 ROWS;

-- 8.View hiện khách hàng có số hóa đơn >=3
Create view HoaDonLonHonBa as
Select tblHoaDon.sMaKhachHang as [Mã khách hàng], Count(tblHoaDon.sMaHoaDon) as [Số hóa đơn]
from tblHoaDon, tblChiTietHoaDon
where tblHoaDon.sMaHoaDon = tblChiTietHoaDon.sMaHoaDon
Group by tblHoaDon.sMaKhachHang
Having Count(tblHoaDon.sMaHoaDon) >= 3;

-- 9.View hiện số phòng của từng loại phòng và sắp xếp theo thứ tự tăng dần
Create view SoPhongLoaiPhongTangDan as
Select sMaLoaiPhong as [Mã loại phòng], Count(sTenPhong) as [Số phòng] 
from tblBangPhong
Group by sMaLoaiPhong
Order by 2
OFFSET 0 ROWS;

-- 10.View tổng số khách hàng một nhân viên chăm sóc/lập hóa đơn
Create view KhachHangTrenNhanVien as
Select H.sMaNhanVien as [Mã nhân viên], Count(H.sMaKhachHang) as [Tổng số khách hàng] 
from tblHoaDon as H, tblNhanVien as N, tblKhachHang as K
where H.sMaKhachHang = K.sMaKhachHang and H.sMaNhanVien = N.sMaNhanVien
Group by H.sMaNhanVien;

-- STORED PROCEDURE - Dinh Hoang Son thuc hien
-- 1.Thêm khách hàng
CREATE PROCEDURE Insert_khachHang
	@MAKH NVARCHAR(10), @TENKH NVARCHAR(20), @PHONE NVARCHAR(20), @EMAIL NVARCHAR(20)
AS
BEGIN
    INSERT INTO tblKhachHang (sMaKhachHang, sTenKhachHang, sPhone, sEmail)
    VALUES (@MAKH, @TENKH, @PHONE, @EMAIL);
END;

-- 2.Xóa khách hàng
CREATE PROCEDURE Delete_KhachHang
    @MAKH NVARCHAR(10)
AS
BEGIN
    DELETE FROM tblKhachHang
    WHERE sMaKhachHang = @MAKH;
END;

-- 3.Thêm nhân viên
CREATE PROCEDURE Insert_nhanVien
	@MANV NVARCHAR(10), @TENNV NVARCHAR(20), @PHONE NVARCHAR(20), @DIACHI NVARCHAR(30), @EMAIL NVARCHAR(20)
AS
BEGIN
	INSERT INTO tblNhanVien
	VALUES (@MANV, @TENNV, @PHONE, @DIACHI, @EMAIL)
END;

-- 4.Xóa nhân viên
CREATE PROCEDURE Delete_NhanVien
	@MANV NVARCHAR(10)
AS
BEGIN
	DELETE FROM tblNhanVien
	WHERE sMaNhanVien = @MANV;
END;

-- 5.Thêm loại phòng
CREATE PROCEDURE Insert_loaiPhong
	@MALP NVARCHAR(10), @TENLP NVARCHAR(20), @MOTA NVARCHAR(50)
AS
BEGIN
	INSERT INTO tblLoaiPhong
	VALUES (@MALP, @TENLP, @MOTA)
END;

-- 6.Xóa loại phòng
CREATE PROCEDURE Delete_LoaiPhong
	@MALP NVARCHAR(10)
AS
BEGIN
	DELETE FROM tblLoaiPhong
	WHERE sMaLoaiPhong = @MALP;
END;

-- 7.Thêm size phòng
CREATE PROCEDURE Insert_sizePhong
	@MASP NVARCHAR(10), @TENLP NVARCHAR(20), @MOTA NVARCHAR(50)
AS
BEGIN
	INSERT INTO tblSizePhong
	VALUES (@MASP, @TENLP, @MOTA)
END;

-- 8.Xóa size phòng
CREATE PROCEDURE Delete_SizePhong
	@MASP NVARCHAR(10)
AS
BEGIN
	DELETE FROM tblSizePhong
	WHERE sMaSizePhong = @MASP;
END;

-- 9.Tìm hóa đơn theo tháng, năm đặt phòng
CREATE PROCEDURE sp_HoaDonTheoThangNam
	@month INT, @year INT
AS
BEGIN
	SELECT sMaHoaDon, dNgayDatPhong, dNgayTraPhong
	FROM tblHoaDon
	WHERE month(dNgayDatPhong) = @month
	AND year(dNgayDatPhong) = @year
END;

EXEC sp_HoaDonTheoThangNam @year = 2023, @month = 10

-- 10.Tìm nhân viên theo địa chỉ
CREATE PROCEDURE sp_NhanVienTheoDiaChi
	@DIACHI NVARCHAR(30)
AS
BEGIN
	SELECT *
	FROM tblNhanVien
	WHERE sDiaChi = @DIACHI
END;

EXEC sp_NhanVienTheoDiaChi @DIACHI = 'Ha Noi'; 

-- 11.Đếm số nhân viên
CREATE PROCEDURE sp_DemNhanVien
AS
BEGIN
	SELECT COUNT(*) AS [Số lượng nhân viên]
	FROM tblNhanVien
END;

EXEC sp_DemNhanVien

-- 12.Đếm số phòng theo trạng thái
CREATE PROCEDURE sp_DemSoPhongTheoTrangThai
AS
BEGIN
	SELECT sTrangThai as [Trạng thái], COUNT(sMaPhong) AS [Số lượng phòng]
	FROM tblBangPhong
	GROUP BY sTrangThai
END;

EXEC sp_DemSoPhongTheoTrangThai

-- 13.Đếm số phòng theo từng loại phòng
CREATE PROCEDURE sp_DemSoPhongTheoLoaiPhong
AS
BEGIN
	SELECT tblBangPhong.sMaLoaiPhong AS [Mã loại phòng], tblLoaiPhong.sTenLoaiPhong AS [Tên loại phòng], COUNT(tblBangPhong.sMaPhong) [Số lượng phòng]
	FROM tblBangPhong, tblLoaiPhong
	WHERE tblBangPhong.sMaLoaiPhong = tblLoaiPhong.sMaLoaiPhong
	GROUP BY tblBangPhong.sMaLoaiPhong, tblLoaiPhong.sTenLoaiPhong
END;

EXEC sp_DemSoPhongTheoLoaiPhong;

-- 14.Sắp xếp thành tiền của hóa đơn theo thứ tự tăng dần
CREATE PROCEDURE sp_ThanhTienHoaDonTangDan
AS
BEGIN
	SELECT tblHoaDon.sMaHoaDon AS [Mã hóa đơn], Sum(tblChiTietHoaDon.fThanhTien) AS [Thành tiền]
	FROM tblHoaDon, tblChiTietHoaDon
	WHERE tblHoaDon.sMaHoaDon = tblChiTietHoaDon.sMaHoaDon
	GROUP BY tblHoaDon.sMaHoaDon
	ORDER BY 2
	OFFSET 0 ROWS
END;

EXEC sp_ThanhTienHoaDonTangDan

-- 15.Tìm kiếm khách hàng theo từng thành phần tên(có thể tìm đầy đủ)
CREATE PROCEDURE sp_TimKiemKhachHangTheoTen
	@TENKH NVARCHAR(20)
AS
BEGIN
	SELECT *
	FROM tblKhachHang
	WHERE sTenKhachHang LIKE '%' + @TENKH + '%';
END;

EXEC sp_TimKiemKhachHangTheoTen @TENKH = 'Hoang';

-- 16.Tổng số khách hàng một nhân viên chăm sóc/lập hóa đơn
CREATE PROCEDURE sp_NhanVien_KhachHang
AS
BEGIN
	SELECT H.sMaNhanVien AS [Mã nhân viên], Count(H.sMaKhachHang) AS [Tổng số khách hàng] 
	FROM tblHoaDon AS H, tblNhanVien AS N, tblKhachHang AS K
	WHERE H.sMaKhachHang = K.sMaKhachHang and H.sMaNhanVien = N.sMaNhanVien
	GROUP BY H.sMaNhanVien
END;

EXEC sp_NhanVien_KhachHang;
-- 17.Tim khach hang theo so dien thoai
CREATE PROCEDURE sp_search_SDTKH
@SDT NVARCHAR(15)
AS

BEGIN
SELECT * FROM tblKhachHang WHERE tblKhachHang.sPhone LIKE '%' + @SDT + '%'
END;
--check
EXEC sp_search_SDTKH 0923848253


-- 18. Sua gia phong theo ma
CREATE PROCEDURE sp_sua_GiaPhong
@gia FLOAT,
@maPhong NVARCHAR(20)
AS BEGIN
UPDATE tblBangPhong SET fGiaPhong = @gia WHERE tblBangPhong.sMaPhong = @maPhong
END;
--check

EXEC sp_sua_giaphong 200,P001

-- 19.Tinh so ngay thue phong cua hoa don
CREATE PROCEDURE sp_NgayThue
AS
BEGIN
SELECT tblHoaDon.sMaHoaDon,DATEDIFF(DAY,tblHoaDon.dNgayDatPhong,tblHoaDon.dNgayTraPhong) AS 'SO NGAY THUE' FROM tblHoaDon
END;
--check
EXEC sp_NgayThue
-- 20.

-- TRIGGER - Quach Dang Thanh thuc hien
-- Tạo trigger thêm nhân viên
CREATE TRIGGER tg_themnv
ON tblNhanVien
AFTER INSERT
AS
    PRINT N'Thêm dữ liệu thành công!'
GO
--Kiểm tra
INSERT INTO tblNhanVien(sMaNhanVien,sTenNhanVien,sPhone,sEmail,sDiaChi) 
VALUES(...)


-- Tạo trigger cật nhật nhân viên
CREATE TRIGGER tg_updtnv
ON tblNhanVien
AFTER UPDATE
AS
    PRINT N'Cật nhật dữ liệu thành công!'
GO
--Kiểm tra
UPDATE tblNhanVien SET ... WHERE 


-- Tạo trigger xóa nhân viên
CREATE TRIGGER tg_xoanv
ON tblNhanVien
AFTER DELETE
AS
    PRINT N'Xóa dữ liệu thành công!'
GO
--Kiểm tra
DELETE tblNhanVien WHERE

drop trigger tg_kothemkhcn;
-- Tạo trigger không cho thêm khách hàng vào Chủ nhật
CREATE TRIGGER tg_kothemkhcn
ON tblKhachHang
AFTER INSERT
AS
    IF DATEPART(DW, GETDATE()) = 1
    BEGIN
        ROLLBACK
        PRINT N'Không thêm dữ liệu vào Chủ nhật!'
    END
GO
--Kiểm tra
INSERT INTO tblKhachHang(sMaKhachHang,sTenKhachHang,sPhone,sEmail)
VALUES(...)
drop trigger tg_kocnkht2;
-- Tạo trigger không cho cật nhật bảng phòng vào thứ 2
CREATE TRIGGER tg_kocnkht2
ON tblBangPhong
AFTER UPDATE
AS
    IF DATEPART(DW, GETDATE()) = 2
    BEGIN
        ROLLBACK
        PRINT N'Không thêm dữ liệu vào Thứ 2!'
    END
GO
--Kiểm tra
UPDATE ...

-- Tạo trigger check nếu bản ghi chèn vào tblbangphong có giá <=100 thì đưa ra thông báo và không insert
CREATE TRIGGER tg_chkbp
ON tblBangPhong
FOR INSERT
AS
	BEGIN
	IF(EXISTS(SELECT*FROM inserted WHERE fGiaPhong <=100))
	BEGIN
    PRINT N'Giá phòng phải lớn hơn 100';
	ROLLBACK TRAN;
	END;
	END;
GO
--Kiểm tra
INSERT INTO

-- Tạo trigger không cho xóa nhiều hơn 1 bản ghi trong tblbangphong
CREATE TRIGGER tg_chkbp1
ON tblBangPhong
FOR DELETE
AS
	BEGIN
	IF((SELECT COUNT(*) FROM deleted) >1)
	BEGIN
    PRINT N'Không thể xóa nhiều hơn 1';
	ROLLBACK TRAN;
	END;
	END;
GO
--Kiểm tra
DELETE

-- Tạo trigger không cho xóa 1 bản ghi trong tblbangphong thì sẽ xóa bản ghi có size phòng giống nhau
CREATE TRIGGER tg_chkbp2
ON tblBangPhong
FOR DELETE
AS
	BEGIN
	DELETE FROM tblBangPhong WHERE sMaSizePhong IN (SELECT sMaSizePhong FROM deleted);
	END;
GO
--Kiểm tra
DELETE

-- Tạo trigger kiểm tra bảng khách hàng
CREATE TRIGGER tg_ktkh ON tblKhachHang
FOR UPDATE
AS
Begin
IF(@@ROWCOUNT =0)
BEGIN  
        PRINT N'Bảng khách hàng không có dữ liệu'
		Return
    END
	ELSE PRINT N'Bảng khách hàng đã có dữ liệu'
End

--Tạo Trigger không cho người dùng thêm/ sửa/ xóa loại phòng vào thứ 7 hoặc cn
CREATE TRIGGER tg_loaiphong
ON tblLoaiPhong
AFTER INSERT, UPDATE, DELETE
AS
    IF DATEPART(dw, GETDATE()) = 7 OR DATEPART(dw, GETDATE()) = 1
    BEGIN
        ROLLBACK
        RAISERROR(N'Không được phép cập nhật dữ liệu!', 16, 1)
        RETURN
    END
GO
--Kiểm tra
INSERT tblLoaiPhong (sMaLoaiPhong, sTenLoaiPhong, sMoTa) 
VALUES(...)
UPDATE tblLoaiPhong SET ... WHERE 
DELETE tblLoaiPhong WHERE 

--Tạo Trigger không cho phép giảm giá phòng
CREATE TRIGGER tg_gp
ON tblBangPhong
AFTER UPDATE
AS
    --Kiểm tra giá mới >= giá cũ
    IF EXISTS(SELECT 1 FROM inserted i JOIN deleted d ON i.sMaPhong = d.sMaPhong WHERE d.fGiaPhong > i.fGiaPhong)
    BEGIN
        ROLLBACK
        RAISERROR(N'Chỉ có tăng giá!', 16, 1)
        RETURN
    END
GO
--Kiểm tra
UPDATE tblBangPhong SET fGiaPhong = fGiaPhong - 100 WHERE sMaPhong = ...
UPDATE tblBangPhong SET fGiaPhong = fGiaPhong + 100 WHERE sMaPhong = ...

drop trigger tg_chkmhd;
--Tạo Trigger kiểm tra nếu Mã Hóa Đơn không có trong bảng Hóa Đơn thì không cho thêm và thông báo lỗi
CREATE TRIGGER tg_chkmhd
ON tblHoaDon
AFTER INSERT
AS
    DECLARE @MaHoaDon Nvarchar(10)
    --Đọc dữ liệu trong bảng tạm inserted
    SELECT @MaHoaDon = sMaHoaDon FROM inserted
    --Kiểm tra mã Hóa Đơn
    IF NOT EXISTS(SELECT 1 FROM tblHoaDon WHERE sMaHoaDon = @MaHoaDon)
    BEGIN
        ROLLBACK
        RAISERROR(N'Mã Hóa Đơn không hợp lệ!', 16, 1)
        RETURN
    END
GO
--Kiểm tra
INSERT tblHoaDon (sMaHoaDon, sMaKhachHang, sMaNhanVien, dNgayDatPhong, dNgayTraPhong, sMaPhong)
VALUES(...) --Được
INSERT tblHoaDon (sMaHoaDon, sMaKhachHang, sMaNhanVien, dNgayDatPhong, dNgayTraPhong, sMaPhong) 
VALUES(...) --Không được

-- Tạo trigger trước kiểm tra tính duy nhất của email
CREATE TRIGGER tr_nhanvienemail
ON tblNhanVien
BEFORE INSERT
AS
BEGIN
    DECLARE @Email Nvarchar
    IF EXISTS (SELECT 1 FROM tblNhanVien WHERE @Email = (SELECT sEmail FROM inserted))
    BEGIN
        RAISEERROR ('Email đã tồn tại trong cơ sở dữ liệu.', 16, 1);
        ROLLBACK;
    END
END;

-- Tạo trigger tự động tăng tổng số hóa đơn
ALTER TABLE tblHoaDon
ADD fTongSoHoaDon FLOAT 

UPDATE tblHoaDon
SET fTongSoHoaDon =0

drop trigger TongHoaDon
CREATE TRIGGER TongHoaDon
ON tblChiTietHoaDon
FOR INSERT 
AS 
BEGIN 
  DECLARE @TongSoHoaDon FLOAT ,@MaHoaDon Nvarchar
  SELECT @MaHoaDon= @MaHoaDon FROM inserted
  SELECT @TongSoHoaDon=(SELECT iSoLuong FROM inserted)

  UPDATE tblHoaDon
  SET fTongSoHoaDon = fTongSoHoaDon + @TongSoHoaDon
  WHERE @MaHoaDon=sMaHoaDon
END

--Kiểm tra
INSERT INTO tblChiTietHoaDon (sMaChiTiet, sMaHoaDon, sMaPhong, sLoaiPhong, sSizePhong, iSoLuong, fGiaPhong, fThanhTien)
VALUES  (...)
--
INSERT INTO tblChiTietHoaDon (sMaChiTiet, sMaHoaDon, sMaPhong, sLoaiPhong, sSizePhong, iSoLuong, fGiaPhong, fThanhTien)
VALUES  (...)
 
SELECT *FROM tblHoaDon
SELECT *FROM tblChiTietHoaDon


--Tạo DDL Trigger trên Server để không cho người dùng tạo Login (tài khoản) (Phần này làm xong phần login sv thì cho vào ko thôi)
USE master
GO
CREATE TRIGGER srv_trg_KhongChoTaoLogin
ON ALL SERVER
FOR CREATE_LOGIN
AS
    PRINT N'Không được phép tạo Login'
    ROLLBACK
GO
--Kiểm tra
CREATE LOGIN User1 WITH PASSWORD = 'Abc123'
GO

--Tạo DDL Trigger trên Server để không cho người dùng đăng nhập ngoài thời gian làm việc (từ 7h đến 17h)
CREATE TRIGGER trg_logon_attempt
ON ALL SERVER
FOR LOGON
AS
BEGIN
IF NOT (DATEPART(hh, GETDATE()) BETWEEN 7 AND 17)
  BEGIN
      ROLLBACK
  END
END
-- PHÂN QUYỀN
CREATE LOGIN thang WITH PASSWORD = 'thang123'
CREATE USER thang FOR LOGIN thang

CREATE LOGIN son WITH PASSWORD = 'son123'
CREATE USER son FOR LOGIN son

CREATE LOGIN duy WITH PASSWORD = 'duy123'
CREATE USER duy FOR LOGIN duy

CREATE LOGIN thanh WITH PASSWORD = 'thanh123'
CREATE USER thanh FOR LOGIN thanh

--role quan ly nhan vien
CREATE ROLE role_qlyNhanVien
GRANT ALL ON tblNhanVien TO role_qlyNhanVien

--role quan ly khach hang
CREATE ROLE role_qlyKhachHang
GRANT ALL ON tblKhachHang TO role_qlyKhachHang


--role quan ly hoa don
CREATE ROLE role_qlyHoaDon
GRANT ALL ON tblHoaDon to role_qlyHoaDon

--cap quyen
ALTER ROLE role_qlyNhanVien ADD MEMBER duy
ALTER ROLE role_qlyHoaDon ADD MEMBER son
ALTER ROLE role_qlyHoaDon ADD MEMBER thanh
ALTER ROLE role_qlyKhachHang ADD MEMBER thang

Select * from tblHoaDon
-- PHÂN TÁN