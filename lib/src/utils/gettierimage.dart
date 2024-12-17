String getTierImage(String? tier) {
  switch (tier) {
    case 'Bronze':
      return 'assets/images/Bronze.png';

    /// Modified File Name
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
      return 'assets/images/Default.png';

    /// default image
  }
}
