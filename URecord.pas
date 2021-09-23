program Pengolahan_Data;
uses crt,sysutils;
const
     maks=100;
     namaFile='DataBuku.DAT';
type
    TBuku=record
                kodeBuku:string[10];
                namaBuku:string[28];
                pengarang:string[19];
                stok:byte;
         end;
     TBukuList=array[1..maks] of TBuku;
var
   buku:TBukuList;
   banyakData:integer;
   pilihanMenu:byte;

procedure tambahData;
begin
     clrscr;
     if banyakData<maks then
     begin
          banyakData:=banyakData+1;
          writeln('Pemasukkan data ke-',banyakData);
          writeln('-------------------------------------------------------------------------------');
          with Buku[banyakData] do
          begin
               write('Kode Buku                : ');readln(kodeBuku);
               write('Judul Buku               : ');readln(namaBuku);
               write('Pengarang                : ');readln(pengarang);
               write('Jumlah Buku Yang Tersedia: ');readln(stok);
          end;
     end
     else
     writeln('Data telah penuh.');
     writeln('-------------------------------------------------------------------------------');
     writeln('Tekan Enter Untuk melanjutkan');
     readln;
end;

procedure viewData;
var
   i:integer;
begin
     clrscr;
     writeln('Data Buku Perpustakaan: ');
     writeln('-------------------------------------------------------------------------------');
     //       12345678901234567890123456789012345678901234567890123456789012345678901234567890
     writeln('| No |  Kode Buku |          Judul Buku          |      Pengarang      | Stok |');
     writeln('-------------------------------------------------------------------------------');
     for i:=1 to banyakData do
     begin
          writeln('|',i:3,' ',
                  '| ',format('%-10s',[buku[i].kodeBuku]),' ',
                  '| ',format('%-28s',[buku[i].namaBuku]),' ',
                  '| ',format('%-19s',[buku[i].pengarang]),' ',
                  '| ',buku[i].stok:3,'  |');
     end;
     writeln('-------------------------------------------------------------------------------');
     writeln('Tekan Enter Untuk Melanjutkan');
     readln;
end;

procedure simpanData;
var
   f:file of TBuku; // File yang menyimpan data TNasabah
   i:integer;
begin
     clrscr;
     writeln('Penyimpanan data ke file');
     writeln('---------------------------');
     assign(f,namafile); // hubungkan ke file
     rewrite(f); // buat file baru
     for i:=1 to banyakData do
         write(f,buku[i]);// tulis nasabah[i] ke file
     close(f);
     writeln('Penyimpanan ',banyakData,' data ke file telah selesai');
     writeln('Tekan Enter Untuk Melanjutkan');
     readln;
end;

procedure bacaData;
var
   f:file of Tbuku;
begin
     clrscr;
     writeln('Pembacaan data dari file');
     writeln('---------------------------');
     assign(f,namafile);// hubungkan ke file
     {$i-}  // Nonaktifkan pemeriksaan IO
     reset(f); // buka file
     {$i+}  // Aktifkan kembali pemeriksaan IO
     if IOResult<>0 then // jika file tidak ditemukan
        rewrite(f); // buat file baru

      banyakData:=0; // banyak data kembali ke 0
      while not eof(f) do // selama belum END-OF-File dari file F
      begin
           banyakData:=banyakData+1;
           read(f,buku[banyakData]);// baca file, simpan di akhir
      end;
      close(f);
      writeln('Pembacaan ',banyakData,' data dari file telah selesai.');
      writeln('Tekan Enter Untuk Melanjutkan');
      readln;
end;

procedure editData;
var
   pilihanEdit:integer;
begin
     clrscr;
     writeln('Pengeditan data dari file');
     writeln('-------------------------------------------------------------------');
     write('Pilih data yang ingin diedit: ');readln(pilihanEdit);
     with buku[pilihanEdit] do
     begin
          write('Kode Buku                : ');readln(kodeBuku);
          write('Judul Buku               : ');readln(namaBuku);
          write('Pengarang                : ');readln(pengarang);
          write('Jumlah Buku Yang Tersedia: ');readln(stok);
     end;
     writeln('Data ke-',pilihanEdit,' telah di edit');
     writeln('Tekan enter untuk melanjutkan');
     readln;
end;

procedure hapusData;
var
   i:integer;
   cari:string;
begin
     clrscr;
     writeln('Hapus Data berdasarkan judul buku');
     writeln('------------------------------------------------------------------');
     write('Pilih buku yang ingin di hapus: ');readln(cari);
     i:=0;
     while (upcase(buku[i].namaBuku)<>upcase(cari)) and (i<banyakData) do
           i:=i+1;
     if upcase(buku[i].namaBuku)=upcase(cari) then
     begin
          buku[i]:=buku[0];
          writeln('Data Buku "',cari,'" Telah dihapus');
     end
     else
         writeln('Data tidak ditemukan');
         writeln;
         writeln('Tekan enter untuk melanjutkan');
         readln;
end;

procedure pencarianData;
var
   dicari:string[28];
   i:integer;
begin
     clrscr;
     writeln('Pencarian berdasarkan Judul Buku');
     writeln('----------------------------------------------------------------');
     write('Judul buku yang dicari: ');readln(dicari);
     i:=1;
     while (upcase(buku[i].namaBuku)<>upcase(dicari))and(i<banyakData) do
           i:=i+1;
     if upcase(buku[i].namaBuku)=upcase(dicari) then
     begin
        writeln('Judul Buku ditemukan di posisi ke-',i);
        writeln('-------------------------------------------------------------------------------');
        //       12345678901234567890123456789012345678901234567890123456789012345678901234567890
        writeln('| No |  Kode Buku |          Judul Buku          |      Pengarang      | Stok |');
        writeln('-------------------------------------------------------------------------------');
        for i:=1 to banyakData do
        begin
          writeln('|',i:3,' ',
                  '| ',format('%-10s',[buku[i].kodeBuku]),' ',
                  '| ',format('%-28s',[buku[i].namaBuku]),' ',
                  '| ',format('%-19s',[buku[i].pengarang]),' ',
                  '| ',buku[i].stok:3,'  |');
          end; 
          writeln('-------------------------------------------------------------------------------');
          writeln;
     end
     else
         writeln('Judul Buku tidak ditemukan');
     writeln('Tekan enter untuk melanjutkan');
     readln;
end;

procedure pengurutanData;
var
   temp:TBukuList;
   i,j:integer;
   indexMin,indexMax:integer;
   pilihan:byte;
begin
     clrscr;
     writeln('Pengurutan data berdasarkan Nama Buku');
     writeln('--------------------------------------------------------------------------------');
     writeln('1. A-Z');
     writeln('2. Z-A');
     write('Pilihan: ');readln(pilihan);
     if pilihan=1 then
     begin
          for i:=1 to banyakData-1 do
          begin
               indexMin:=i;
               for j:=banyakData downto i+1 do
               begin
                    if buku[j].namaBuku<buku[indexMin].namaBuku then
                    indexMin:=j;
               end;
               temp[i]:=buku[i];
               buku[i]:=buku[indexMin];
               buku[indexMin]:=temp[i];
          end;
          end
          else if pilihan=2 then
          begin
               for i:=1 to banyakData-1 do
               begin
                    indexMax:=i;
                    for j:=i+1 to banyakData do
                    begin
                         if buku[j].namaBuku>buku[indexMax].namaBuku then
                         indexMax:=j;
                    end;
                    temp[i]:=buku[i];
                    buku[i]:=buku[indexMax];
                    buku[indexMax]:=temp[i];
               end;
          end;
          writeln('Pengurutan selesai');
          write('Tekan enter untuk melanjutkan');readln;
          writeln('Data Buku Perpustakaan: ');
          writeln('-------------------------------------------------------------------------------');
          //       12345678901234567890123456789012345678901234567890123456789012345678901234567890
          writeln('| No |  Kode Buku |          Judul Buku          |      Pengarang      | Stok |');
          writeln('-------------------------------------------------------------------------------');
          for i:=1 to banyakData do
          begin
              writeln('|',i:3,' ',
                  '| ',format('%-10s',[buku[i].kodeBuku]),' ',
                  '| ',format('%-28s',[buku[i].namaBuku]),' ',
                  '| ',format('%-19s',[buku[i].pengarang]),' ',
                  '| ',buku[i].stok:3,'  |');
          end;
          writeln('-------------------------------------------------------------------------------');
          writeln('Tekan Enter Untuk Melanjutkan');
          readln;
end;

begin
     banyakData:=0;// inisialisasi banyakData
     repeat
           clrscr;
           writeln('Menu Pilihan');
           writeln('---------------------------------');
           writeln('1. Penambahan data');
           writeln('2. View Data');
           writeln('3. Simpan Data Ke File');
           writeln('4. Baca Data Dari File');
           writeln('5. Edit Data Dari File');
           writeln('6. Hapus Data Dari File');
           writeln('7. Cari Data Dari File');
           writeln('8. Pengurutan Data Dari File');
           writeln('0. Keluar dari aplikasi');
           writeln('---------------------------------');
           write('Pilihan Anda : ');readln(pilihanMenu);// aksi sesuai menu akan ditulis di sini.
           case pilihanMenu of
                1:tambahData;
                2:viewData;
                3:simpanData;
                4:bacaData;
                5:editData;
                6:hapusData;
                7:pencarianData;
                8:pengurutanData;
           end;
     until pilihanMenu=0;
end.
