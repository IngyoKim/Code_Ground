import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  /// Help Sections List
  final List<Map<String, String>> helpSections = [
    {
      'title': '문제 유형',
      'content':
          '총 5 가지의 문제 유형을 제공합니다.\n\nSyntax (구문 오류): 이 유형은 코드에서 문법적인 오류를 찾고 수정하는 문제입니다. 사용자는 코드에서 잘못된 문법을 찾아야 하며, 올바른 구문으로 수정해야 합니다. 예를 들어, 괄호의 짝이 맞지 않거나 세미콜론이 빠진 경우 등이 포함될 수 있습니다.\n\nDebugging (디버깅): 디버깅 문제는 주어진 코드에서 발생하는 오류나 버그를 찾아 수정하는 문제입니다. 코드가 의도한 대로 동작하지 않는 이유를 파악하고, 그 문제를 해결하기 위해 코드의 흐름을 수정해야 합니다.\n\nOutput (출력): 출력 문제는 주어진 코드의 실행 결과를 예측하는 문제입니다. 사용자는 코드가 실행된 후 출력되는 값을 예상하고, 그 값을 정확하게 맞추어야 합니다. \n\nBlank (빈칸 채우기): 빈칸 채우기 문제는 코드에서 일부가 빈칸으로 제공되며, 이를 적절한 코드로 채워 넣는 문제입니다. 코드의 일부가 누락된 상태에서 요구하는 결과를 얻을 수 있도록 올바른 문법을 사용하여 코드를 완성해야 합니다.\n\nSequencing (순서 맞추기): 순서 정하기 문제는 주어진 코드나 명령어들이 올바르게 실행될 수 있도록 순서를 맞추는 문제입니다. 여러 코드 조각이나 명령어들이 있을 때, 그들이 올바른 순서로 실행되도록 배열하는 문제입니다.',
    },
    {
      'title': '티어 표',
      'content':
          '*모든 티어는 score 기준으로 나뉩니다.\n브론즈: 0-499\n실버: 500-1999\n골드: 2000-4999\n플래티넘: 5000-9999\n다이아: 10000-29999\n마스터: 30000-49999\n그랜드마스터: 50000-',
    },
    {
      'title': '역할별 권한 범위',
      'content':
          '역할은 3단계로 나뉩니다.\n\nMember - 문제 풀기만 가능\nOperator - 문제 풀기, 수정 가능\nMaster - 문제 풀기, 수정, 생성 가능',
    },
  ];

  /// Track selection status for Help sections
  final List<bool> _isExpanded = List.generate(3, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: helpSections.length,
          itemBuilder: (context, index) {
            final section = helpSections[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ExpansionTile(
                title: Row(
                  children: [
                    const Icon(
                      Icons.help_outline,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8.0),
                    Flexible(
                      /// Adjust text width for remaining space
                      child: Text(
                        section['title']!,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
                initiallyExpanded: _isExpanded[index],

                /// Set Open/Close to Existing Status Values
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _isExpanded[index] = expanded;

                    /// Update Open/Closed Status
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      section['content']!,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
