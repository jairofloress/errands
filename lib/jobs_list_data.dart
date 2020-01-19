class JobsListData {
  JobsListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.task,
    this.cost = 0,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  String task;
  int cost;

  static List<JobsListData> tabIconsList = <JobsListData>[
    JobsListData(
      imagePath: 'assets/painter.png',
      titleTxt: 'Painter',
      cost: 525,
      startColor: '#738AE6',
      endColor: '#5C5EDD',
      task: 'Get home painted',
    ),
    JobsListData(
      imagePath: 'assets/plumber.png',
      titleTxt: 'Plumber',
      cost: 602,
      startColor: '#FA7D82',
      endColor: '#FFB295',
      task: 'Get your taps turned',
    ),
    JobsListData(
      imagePath: 'assets/cook.png',
      titleTxt: 'Cook',
      cost: 700,
      startColor: '#6F72CA',
      endColor: '#1E1466',
      task: 'Don\'t wanna cook?',
    ),
    JobsListData(
      imagePath: 'assets/gardener.png',
      titleTxt: 'Gardener',
      cost: 200,
      startColor: '#FE95B6',
      endColor: '#FF5287',
      task: 'Get your house cleaned',
    ),
  ];
}
