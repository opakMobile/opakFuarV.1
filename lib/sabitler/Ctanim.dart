class Ctanim {
  //degiskenler
  static var db;









  //fonksiyonalar
  static List cariIlkIkiDon(String text) {
    String trim = text.trim();
    String harf1 = "";
    String harf2 = "";
    if (trim.length > 0) {
      harf1 = trim[0];
      if (trim.length == 1) {
        harf2 = "K";
      } else {
        harf2 = trim[1];
      }
    } else {
      harf1 = "A";
      harf2 = "B";
    }
    return [harf1, harf2];
  }
}
