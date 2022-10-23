import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mind_base/src/core/config/assets/assets.gen.dart';
import 'package:mind_base/src/user/infra/ui/widget/rounded_button.dart';
import 'package:mind_base/src/user/infra/ui/widget/rounded_input_field.dart';
import 'package:mind_base/src/user/infra/ui/widget/rounded_password_field.dart';
import 'package:mind_base/src/user/domain/value/value.dart';
import 'dart:math' as m;

Future<AuthReq?> showAuthDialog({
  required BuildContext context,
  AuthReq? origin,
  AuthRsp? withRsp,
}) {
  // 获取窗口宽高
  final height = m.min(MediaQuery.of(context).size.width, 720.0);
  final width = height * 0.62;
  return showDialog(
      context: context,
      builder: (c) => Dialog(
            child: SizedBox(
              child: Body(originReq: origin, rsp: withRsp),
              height: height,
              width: width,
            ),
            clipBehavior: Clip.hardEdge, // 确保内容不超出Dialog之外(特指圆角部分)
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ));
}

class Body extends StatefulWidget {
  // 登录按钮及其排序(首个元素即为首选登录项)
  final List<AuthTp> authList;
  final bool initIsRegister;
  final AuthReq? originReq;
  final AuthRsp? rsp;

  const Body({
    Key? key,
    this.initIsRegister = false,
    this.authList = const [
      AuthTp.email,
    ],
    this.originReq,
    this.rsp,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
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

  String get describeAuthVerify {
    switch (authVerify) {
      case AuthTp.email:
        return "邮箱";
      // case AuthTp.phoneNumber:
      //   return "手机号";
      // case AuthTp.wechatOfficial:
      //   return "微信公众号";
      // case AuthTp.qqConnect:
      //   return "QQ登录";
      // case AuthTp.qqNumber:
      //   return "QQ号";
      // case AuthTp.github:
      //   return 'GitHub';
    }
  }

  IconData _getAuthVerifyIcon(AuthTp authVerify) {
    switch (authVerify) {
      // case AuthTp.qqNumber:
      //   return LineIcons.qq;
      case AuthTp.email:
        return LineIcons.envelope;
      // case AuthTp.phoneNumber:
      //   return LineIcons.phone;
      // case AuthTp.qqConnect:
      //   return LineIcons.qq;
      // case AuthTp.wechatOfficial:
      //   return LineIcons.weixinWechat;
      // case AuthTp.github:
      //   return LineIcons.github;
    }
  }

  String? authVerifyValidator(String? v) {
    switch (authVerify) {
      case AuthTp.email:
        return Email.validator(v);
      // case AuthTp.phoneNumber:
      //   return PhoneNumber.validator(v);
      // case AuthTp.qqNumber:
      //   return QQNumber.validator(v);
      // case AuthTp.qqConnect:
      // case AuthTp.wechatOfficial:
      // case AuthTp.github:
      //   throw BaseException('[$authVerify]无需校验', debugInfo: '逻辑错误');
    }
  }

  switchAuthVerify(AuthTp verify) {
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
      secondChild: Positioned(
          top: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16),
            child: TextButton(
              child: const Icon(Icons.close),
              onPressed: Navigator.of(context).pop,
            ),
          )),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  isRegister ? "注册" : "登录",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),
                isRegister
                    ? Assets.images.login.svg(height: size.height * 0.35)
                    : Assets.images.signup.svg(height: size.height * 0.35),
                // 展示上次请求的错误信息
                if (widget.rsp != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder(
                        future: Future.delayed(const Duration(seconds: 5)),
                        builder: (c, s) =>
                            (s.connectionState == ConnectionState.done)
                                ? const SizedBox()
                                : Text(
                                    "${widget.rsp!.msg}",
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 18),
                                  )),
                  ),
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
                    onPressed: () => switchAuthVerify(auth),
                    icon: Icon(_getAuthVerifyIcon(auth)),
                  ))
              .toList(),
        )
      ];

  List<Widget> _buildInputField(BuildContext ctx) {
    switch (authVerify) {
      case AuthTp.email:
        // case AuthTp.phoneNumber:
        return [
          RoundedInputField(
            hintText: describeAuthVerify,
            validator: authVerifyValidator,
            onChanged: setIdentityStr,
          ),
          RoundedPasswordField(
            validator: (v) => Password.validator(v),
            onChanged: setPwd,
          ),
          RoundedButton(
            text: isRegister ? "注册" : "登陆",
            press: () async {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pop(AuthReq(
                  isRegister,
                  authVerify,
                  identityStr,
                  pwd,
                ));
              }
            },
            color: Theme.of(context).primaryColor,
          )
        ];
      // case AuthTp.qqNumber:
      //   return [const Text("尚未支持QQ号 注册/登录")];
      // case AuthTp.wechatOfficial:
      //   return [const Text("尚未支持公众号 注册/登录")];
      // case AuthTp.qqConnect:
      //   return [const Text("尚未支持QQ 注册/登录")];
      // case AuthTp.github:
      //   return [const Text("尚未支持GitHub 注册/登录")];
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
            child: Image.asset(
              Assets.images.signupTop.path,
              width: widthFactor * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              Assets.images.mainBottom.path,
              width: widthFactor * 0.25,
            ),
          ),
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
