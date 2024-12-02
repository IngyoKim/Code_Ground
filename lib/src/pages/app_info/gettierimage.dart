String getTierImage(String? tier) {
  switch (tier) {
    case 'Bronze':
      return 'assets/images/Bronz.jpg';
    case 'Silver':
      return 'assets/images/Silver.jpg';
    case 'Gold':
      return 'assets/images/Gold.jpg';
    case 'Platinum':
      return 'assets/images/Platinum.jpg';
    case 'Diamond':
      return 'assets/images/Dia.jpg';
    case 'Master':
      return 'assets/images/Master.jpg';
    case 'Grand Master':
      return 'assets/images/GrandMaster.jpg';
    default:
      return 'assets/images/Default.jpg'; // 기본 이미지
  }
}
