import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'login_screen.dart';

class UnregisteredContent extends StatefulWidget {
  const UnregisteredContent({Key? key}) : super(key: key);

  @override
  _UnregisteredContentState createState() => _UnregisteredContentState();
}

class _UnregisteredContentState extends State<UnregisteredContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  int _currentPageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat(reverse: true);

    _colorAnimation = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.grey, end: Colors.black),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.black, end: Colors.grey),
        weight: 1,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                // Page 1 content
                Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/images/aa.jpg',
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: AnimatedBuilder(
                            animation: _colorAnimation,
                            builder: (context, child) {
                              return Text(
                                'Добро пожаловать в Drivly',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: _colorAnimation.value,
                                ),
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          child: Text(
                            'Откройте мир приключений с нашим сервисом аренды автомобилей! От городских круизов до путешествий на природе - ваш выбор, ваше приключение! Широкий выбор автомобилей для аренды, от экономичных до премиум-класса. А еще - форум для автолюбителей, где можно обсудить, поделиться опытом и найти вдохновение. Добро пожаловать в мир свободы на дороге и общения с единомышленниками!',
                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        // Add more text widgets here as needed
                      ],
                    ),
                  ),
                ),
                // Page 2 content
                Container(
                  color: Colors.white, // Set background color to white
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/images/aa.jpg',
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20.0),
                        // Text for page 2
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Мы предлагаем уникальное сочетание преимуществ, делающих нас идеальным выбором для вашего следующего приключения. С нами вы получаете:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                '1) Широкий выбор автомобилей: от экономичных моделей до премиум-класса, чтобы каждый нашел идеальный вариант.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                '2) Гибкие условия аренды: у нас вы сами выбираете срок и условия аренды, а также можем предложить удобные тарифы.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                '3) Простой процесс бронирования: мы делаем процесс аренды максимально удобным и быстрым, чтобы вы могли сконцентрироваться на своем приключении.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                '4) Служба поддержки 24/7: наша команда всегда готова помочь вам в любое время суток.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        // Add more text widgets here as needed
                      ],
                    ),
                  ),
                ),
                // Page 3 content
                Container(
                  color: Colors.white, // Set background color to white
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/images/mel.jpg',
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20.0),
                        // Text for page 3
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Мы предлагаем разнообразие вариантов, соответствующих вашему бюджету и потребностям:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                '- Бюджетные автомобили: идеальный выбор для тех, кто ценит экономию, с ценой от 500 до 1000 рублей в сутки.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                '- Комфортные модели: для уютного и беззаботного путешествия по доступной цене от 2000 до 3000 рублей в сутки.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                '- Грузовые автомобили: если вам нужен надежный транспорт для перевозки грузов, мы предлагаем широкий выбор по цене от 3000 до 5000 рублей в сутки.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                '- Бизнес-класс: для особых случаев и важных встреч доступны роскошные автомобили по цене от 15000 рублей в сутки и выше.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        // Add more text widgets here as needed
                      ],
                    ),
                  ),
                ),
                // Page 4 content
                Container(
                  color: Colors.white, // Set background color to white
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/images/aa.jpg',
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20.0),
                        // Text for page 4
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'Перед тем как отправиться в увлекательное путешествие с нашими автомобилями в аренду, пожалуйста, ознакомьтесь с требованиями документов:',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  '1) Водительское удостоверение: действительное и соответствующее вашему возрасту.',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  '2) Паспорт: для подтверждения личности.',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  '3) Кредитная или дебетовая карта: для оформления залога или оплаты.',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  '4) Кроме того, убедитесь, что вы соответствуете возрастным ограничениям, определенным для каждой категории автомобилей.',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                'Наша команда с удовольствием поможет вам с оформлением всех необходимых документов и ответит на все ваши вопросы, чтобы ваше путешествие началось с легкости и уверенности.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        // Add more text widgets here as needed
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          // Indicators for page navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4, // Total number of pages
                  (index) => Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPageIndex == index ? Colors.black : Colors.grey, // Change colors as needed
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          // Bottom navigation bar
          BottomAppBar(
            color: Colors.transparent,
            child: Container(
              height: 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4, // Total number of pages
                      (index) => Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPageIndex == index ? Colors.black : Colors.grey, // Change colors as needed
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: FloatingActionButton.extended(
          onPressed: () {
            _handleRegisterButtonPressed(context);
          },
          label: Text(
            'Присоединиться к нам',
            style: TextStyle(color: Colors.black),
          ),
          icon: Icon(Icons.person_add, color: Colors.black),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  void _handleRegisterButtonPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.login),
                title: Text('Войти'),
                onTap: () {
                  Navigator.pop(context); // Закрываем модальное окно
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text('Зарегистрироваться'),
                onTap: () {
                  Navigator.pop(context); // Закрываем модальное окно
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}