import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({Key? key}) : super(key: key);

  final String _terms = '''
# 서비스이용약관(2025.10.13)

제1조 (목적)
이 약관은 회사(이하 "본사"라 합니다)가 제공하는 서비스의 이용과 관련하여 본사와 이용자의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

제2조 (정의)
1. "서비스"란 본사가 제공하는 모든 온라인 및 오프라인 서비스를 의미합니다.
2. "이용자"란 본사의 서비스에 접속하여 이 약관에 따라 본사의 서비스를 받는 회원 및 비회원을 말합니다.

제3조 (약관의 효력 및 변경)
1. 본 약관은 서비스 화면에 게시하거나 기타의 방법으로 이용자에게 공지함으로써 효력을 발생합니다.
2. 본사는 관련 법령을 위배하지 않는 범위에서 이 약관을 변경할 수 있으며, 변경된 약관은 제1항과 같은 방법으로 공지 또는 통지함으로써 효력을 발생합니다.

제4조 (서비스의 제공 및 변경)
1. 본사는 다음과 같은 서비스를 제공합니다.
   가. 콘텐츠 제공 서비스
   나. 커뮤니티 서비스
   다. 기타 본사가 정하는 서비스
2. 본사는 서비스의 내용 및 제공일정을 변경할 수 있으며, 변경 시 사전에 공지합니다.

제5조 (서비스 이용계약의 성립)
1. 이용계약은 이용자가 약관에 동의하고 회원가입을 신청한 후 본사가 이를 승낙함으로써 성립합니다.
2. 본사는 다음 각 호에 해당하는 신청에 대하여는 승낙을 하지 않을 수 있습니다.
   가. 타인의 명의를 도용하여 신청한 경우
   나. 허위의 정보를 기재하여 신청한 경우
   다. 기타 본사가 정한 이용신청 요건을 충족하지 못한 경우

제6조 (회원정보의 변경)
이용자는 회원정보가 변경되었을 경우 즉시 온라인으로 수정하여야 하며, 변경하지 않아 발생하는 불이익은 이용자가 부담합니다.

제7조 (서비스 이용시간)
서비스 이용은 본사의 업무상 또는 기술상 특별한 지장이 없는 한 연중무휴, 1일 24시간을 원칙으로 합니다.

제8조 (서비스 이용의 제한 및 중지)
본사는 다음 각 호에 해당하는 경우 서비스 이용을 제한하거나 중지할 수 있습니다.
1. 이용자가 본 약관을 위반한 경우
2. 기타 본사가 서비스 제공을 위해 필요하다고 인정하는 경우

제9조 (이용자의 의무)
이용자는 다음 행위를 하여서는 안 됩니다.
1. 신청 또는 변경 시 허위 내용의 등록
2. 타인의 정보 도용
3. 본 서비스의 운영을 방해하는 행위
4. 기타 불법적이거나 부당한 행위

제10조 (저작권의 귀속 및 이용제한)
1. 본사가 작성한 저작물에 대한 저작권 및 기타 지적재산권은 본사에 귀속합니다.
2. 이용자는 서비스를 이용함으로써 얻은 정보를 본사의 사전 승낙 없이 복제, 전송, 출판, 배포, 방송 기타 방법으로 이용하거나 제3자에게 이용하게 하여서는 안 됩니다.

제11조 (면책조항)
본사는 천재지변, 불가항력적 사유 및 이용자의 귀책사유로 인한 서비스 이용 장애에 대하여 책임을 지지 않습니다.

제12조 (분쟁해결)
본 약관과 관련하여 분쟁이 발생한 경우 본사와 이용자는 상호 협의하여 해결하며, 협의가 이루어지지 않을 경우 본사 소재지를 관할하는 법원을 제1심 관할 법원으로 합니다.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text('이용약관'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Markdown(
          data: _terms,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            p: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
            ),
            h1: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            h2: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
