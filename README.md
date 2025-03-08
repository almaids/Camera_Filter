# biodatasaya


### Void Async pada Praktikum 1
Pada praktikum 1, fungsi `void async` digunakan pada deklarasi fungsi `main()`.  
Maksud dari penggunaan `Future async` pada fungsi `main` adalah untuk memungkinkan penggunaan sintaks `await` di dalam fungsi tersebut. Tanpa menggunakan `async-await`, aplikasi mungkin akan mencoba berjalan sebelum komponen-komponen penting seperti Firebase dan kamera siap digunakan, yang dapat menyebabkan error atau crash.

### Fungsi dari Anotasi `@immutable` dan `@override`
- **Anotasi `@immutable`**  
  Digunakan untuk menyatakan bahwa suatu kelas **tidak dapat diubah** setelah dibuat.  
  Hal ini mengharuskan semua propertinya bersifat **final**, yang membantu meningkatkan **performa dan keamanan tipe** pada aplikasi.  

- **Anotasi `@override`**  
  Digunakan untuk menandai bahwa suatu metode **menimpa** implementasi metode dari **kelas induknya**.  
  Anotasi ini membantu **compiler mendeteksi kesalahan** penulisan nama metode dan meningkatkan **keterbacaan kode** bagi developer lain.

### Demonstrasi Proyek  
[Klik di sini untuk melihat demonstrasi proyek](https://drive.google.com/file/d/169f0L2wdHjsMQegiX5gPCSZteyOsnHy6/view?usp=drive_link)
