import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/core/config/config.dart';
import 'dart:math' as m;

import 'package:provider_sidecar/provider_sidecar_ex.dart';

part 'auth.g.dart';

@TypedGoRoute<AuthRoute>(path: '/auth/:login', routes: [])
class AuthRoute extends GoRouteData {
  final bool login;

  const AuthRoute(this.login);

  const AuthRoute.auto([this.login = true]);

  @override
  Widget build(BuildContext context) => AuthPage(login: login);
}

class AuthPage extends StatefulWidget {
  final bool login;

  const AuthPage({Key? key, this.login = true}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with OnInitStateMx<AuthPage, AppModel> {
  @override
  onInitState(msgr, m) => m.events.listen((evt) => evt.maybeWhen(
      msg: (msg) => msgr.showSnackBar(SnackBar(content: Text(msg))),
      orElse: () => null));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Body(
      initIsRegister: !widget.login,
    ));
  }
}

class Body extends StatefulWidget {
  // 登录按钮及其排序(首个元素即为首选登录项)
  final List<AuthTp> authList;
  final bool initIsRegister;

  const Body({
    Key? key,
    this.initIsRegister = false,
    this.authList = const [
      AuthTp.email,
    ],
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late GlobalKey<FormState> _formKey;
  late AuthTp authVerify; // identity 当前的含义
  late String identityStr; //authVerify的值 可以是email, QQ号, 或者其他

  late String pwd;

  late bool isRegister;

  @override
  void initState() {
    assert(widget.authList.isNotEmpty, "auth至少需要一种登录方式");
    _formKey = GlobalKey<FormState>();
    authVerify = widget.authList.first;
    identityStr = '';
    pwd = '';
    isRegister = widget.initIsRegister;
    super.initState();
  }

  String get describeAuthTp {
    switch (authVerify) {
      case AuthTp.email:
        return "邮箱";
    }
  }

  IconData _getAuthTpIcon(AuthTp authVerify) {
    switch (authVerify) {
      case AuthTp.email:
        return LineIcons.envelope;
    }
  }

  String? authVerifyValidator(String? v) {
    switch (authVerify) {
      case AuthTp.email:
        return const EmailValidator(errorMsg: '请填写正确的邮箱地址').call(v);
    }
  }

  switchAuthTp(AuthTp verify) {
    if (verify != authVerify) {
      setState(() {
        authVerify = verify;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.03),
                isRegister
                    ? Assets.images.login.svg(height: size.height * 0.35)
                    : Assets.images.signup.svg(height: size.height * 0.35),
                ..._buildInputField(context),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  login: isRegister,
                  press: () => setState(() => isRegister = !isRegister),
                ),
                // 有2种以上登录方式时,展示登录选项栏
                if (widget.authList.length >= 2)
                  ..._buildAuthOptionsRow(widget.authList),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAuthOptionsRow(List<AuthTp> authList) => [
        const OrDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: authList
              .map((auth) => IconButton(
                    onPressed: () => switchAuthTp(auth),
                    icon: Icon(_getAuthTpIcon(auth)),
                  ))
              .toList(),
        )
      ];

  List<Widget> _buildInputField(BuildContext ctx) {
    switch (authVerify) {
      case AuthTp.email:
        return [
          RoundedInputField(
            hintText: describeAuthTp,
            validator: authVerifyValidator,
            onChanged: setIdentityStr,
          ),
          RoundedPasswordField(
            validator: (v) => const LengthRangeValidator(
                    min: 8, max: 64, errorMsg: '密码长度只能在8到64个字符之间')
                .call(v),
            onChanged: setPwd,
          ),
          RoundedButton(
            text: isRegister ? "注册" : "登陆",
            press: () async {
              if (_formKey.currentState!.validate()) {
                context.read<AppModel>().actEntrance(
                      isRegister
                          ? AppAct.signupLogin(
                              authVerify: authVerify,
                              identityStr: identityStr,
                              password: pwd)
                          : AppAct.login(
                              authVerify: authVerify,
                              identityStr: identityStr,
                              password: pwd),
                    );
              }
            },
            color: Theme.of(context).primaryColor,
          )
        ];
    }
  }

  void setIdentityStr(String value) => identityStr = value;

  void setPwd(String value) => pwd = value;
}

class Background extends StatelessWidget {
  final Widget child;
  final Widget? secondChild;

  const Background({
    Key? key,
    required this.child,
    this.secondChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final widthFactor = m.min(size.width, 450);
    return SizedBox(
      height: size.height,
      width: double.infinity,
      // Here i can use size.width but use double.infinity because both work as a same
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: Assets.images.signupTop.image(width: widthFactor * 0.35)),
          Positioned(
              bottom: 0,
              left: 0,
              child: Assets.images.mainBottom.image(width: widthFactor * 0.25)),
          child,
          if (secondChild != null) secondChild!,
        ],
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OR",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return const Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final String iconSrc;
  final void Function()? press;

  const SocialIcon({
    Key? key,
    required this.iconSrc,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: press,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Theme.of(context).primaryColor,
            ),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            iconSrc,
            height: 20,
            width: 20,
          ),
        ),
      );
}

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final void Function()? press;

  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            login ? "已有账号 ? " : "没有账号 ? ",
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 14),
          ),
          GestureDetector(
            onTap: press,
            child: Text(
              login ? "登录" : "注册",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          )
        ],
      );
}

class TextFieldContainer extends StatelessWidget {
  final Widget? child;
  final double radius;

  const TextFieldContainer({
    Key? key,
    this.child,
    this.radius = 29,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final double radius;

  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.validator,
    this.radius = 19,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFieldContainer(
        radius: radius,
        child: TextFormField(
          onChanged: onChanged,
          cursorColor: Theme.of(context).primaryColor,
          validator: validator,
          decoration: InputDecoration(
            icon: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            hintText: hintText,
            border: InputBorder.none,
          ),
        ),
      );
}

class RoundedPasswordField extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const RoundedPasswordField({
    Key? key,
    this.hintText,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool canObs = false;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: !canObs,
        onChanged: widget.onChanged,
        cursorColor: Theme.of(context).primaryColor,
        validator: widget.validator,
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: Icon(
            Icons.lock,
            color: Theme.of(context).primaryColor,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.visibility),
            color: Theme.of(context).primaryColor,
            onPressed: () => setState(() => canObs = !canObs),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? press;
  final Color color, textColor;

  const RoundedButton({
    Key? key,
    required this.text,
    this.press,
    required this.color, // Theme.of(context).primaryColor
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(29),
            child: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                  (s) =>
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) => color,
                ),
              ),
              onPressed: press,
              child: Text(
                text,
                style: TextStyle(color: textColor),
              ),
            ),
          ),
        ),
      );
}
