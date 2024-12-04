//임시 위치임. utils로 옮길 예정
String getTierImage(String? tier) {
  switch (tier) {
    case 'Bronze':
      return 'assets/images/Bronz.png'; // 수정된 파일 이름
    case 'Silver':
      return 'assets/images/Silver.png';
    case 'Gold':
      return 'assets/images/Gold.png';
    case 'Platinum':
      return 'assets/images/Platinum.png';
    case 'Diamond':
      return 'assets/images/Dia.png';
    case 'Master':
      return 'assets/images/Master.png';
    case 'Grand Master':
      return 'assets/images/GrandMaster.png';
    default:
      return 'assets/images/Default.png'; // 기본 이미지
  }
}
