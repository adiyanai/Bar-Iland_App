import 'package:http/http.dart' as http;
import 'dart:convert';


  final databaseURL = 'https://bar-iland-app.firebaseio.com/importantLinks';

     List<String> facultiesTypeList = [
      'jewishStudies',// מדעי היהדות 
      'socialScience',// מדעי החברה
      'humanities',// מדעי הרוח
      'exactSciences', // מדעים מדויקים
      'engineering', // הנדסה  
      'lifeScience',// מדעי החיים
      'laws',// משפטים
      'medicine',// רפואה
      'interdisciplinaryStudies', // לימודים בין תחומיים
      'general' //כללי
    ];

    Future<bool> createFacultiesTypeList() {
      
      List<Map<String, List <String>>> jewish_studies_degrees_list = [
          {'מזרח תיכון' : ['https://drive.google.com/drive/folders/0B9zVwjzawwhoa1ZjRTQ5WE5vblE?usp=sharing','מזרח תיכון']},
          {'מחשבת ישראל בן גוריון':['https://drive.google.com/drive/folders/0B2eUHjUCcxU5M0NFR1hqd2NNdEk?fbclid=IwAR3we5n6531jrXABE72VbmnPzoXQ8ixqqqwjs5TBbyckVmN44cBXj5hwC7g','מחשבת ישראל בן גוריון']},
          {'לימודי יסוד ביהדות':['https://drive.google.com/drive/folders/0B-Tn16JJkVZAT2RPYmptNGpya1U?fbclid=IwAR0sV10BKLVrhl0RGOqBzKiiCAoEtuMhrJkDSgtcISSIIyvkdwS6z5MaCrA','קורסי יהדות וקורסים כלליים']},
        ];

      List<Map<String, List <String>>> exact_sciences_degrees_list = [
        {'מדעי המחשב':['https://drive.google.com/drive/u/0/folders/0B_dY_D5Av8zpY19UenV3bTdNejA','מדעי המחשב']},
        {'מתמטיקה':['https://drive.google.com/drive/folders/0B2oHIRemGkBOblpnbkxtOHQyM0U?sort=13&direction=a&fbclid=IwAR0e2z3W90onKCopV28FO7ES5Kv-AJVXzNast11Hp1IHupbba5AM8RVuwtw','מתמטיקה']},
        { 'כימיה': ['https://drive.google.com/drive/mobile/folders/0Bx21WFmPdyBFNldSX2M0TjhaeEk?usp=sharing','כימיה']},
        {'מדעי המחשב אוניברסיטת בן גוריון': ['https://drive.google.com/drive/folders/0B55cpp7lk7EbODhFc21VY0U2ZFU','מדעי המחשב אוניברסיטת בן גוריון']}
        ];
      
      List<Map<String, List <String>>> engineering_degrees_list = [
        {'הנדסה':['http://bit.ly/DriveEngBIU','הנדסה 1']},
        {'הנדסה':['https://drive.google.com/drive/folders/0B5IihO1SWWsCYlV2VW5DQjQyZEE','הנדסה 2']},
        ];
    
        List<Map<String, List <String>>> life_science_list = [
        {'ביואינפורמטיקה':['https://drive.google.com/drive/folders/0B2l2zhy1dwWnYm5LcHR0c1g3Y2M','ביואינפורמטיקה']},
        {'מדעי החיים':['https://drive.google.com/drive/folders/0B5teLgiVzPqKRVRxZFpQbVlLN0E?usp=sharing','מדעי החיים דרייב']},
        {'מדעי החיים':['https://app.box.com/s/g1azexvhz57hgdaa7jutcpzh82wwepb3','מדעי החיים שנה א סמסטר א']},
        {'מדעי החיים':['https://app.box.com/s/k6p94u8supnzyjr5j1ul2i43musg0e37','מדעי החיים שנה א סמסטר ב']},
        {'מדעי החיים':['https://app.box.com/s/rd0penn6oqfuka0mrvua9n5a6uhmk2mb','מדעי החיים שנה ב סמסטר א']},
        {'מדעי החיים':['https://app.box.com/s/qbsxvz0spwq0wacpdtvq507chfxcofko','מדעי החיים שנה ב סמסטר ב']},
        {'מדעי החיים':['https://app.box.com/s/u4aadfqoyk18f1ab1fc2u9ylw8vq3cag/folder/4968633234','מדעי החיים שנה ג']},
        ];
        
        List<Map<String, List <String>>> interdisciplinary_studies_degrees_list = [
          {'מדעי המוח' : ['https://drive.google.com/drive/folders/1h2C_SMY-kLRcNa_PVfIcmqrOVkqEigTS','מדעי המוח']},
        ];
        
        List<Map<String, List <String>>> general_degrees_list = [
          {'דרייב של אוניברסיטת תל אביב' : ['https://drive.google.com/drive/folders/1BtcBIpl_zTht1KWKR7Qjl_RoavkmfQG0','דרייב של אוניברסיטת תל אביב']},
        ];

        List<Map<String, List <String>>> social_sciences_degrees_list = [
          {'חינוך' : ['https://drive.google.com/drive/folders/0BxXWUiCbLpa4VG15cnFJMTJUMFE?fbclid=IwAR34G3LaOyRDEc0njRH_l9PqJpK6tL-OYDBz673BADhV5JGVm_00tm2tEvk','חינוך']},
          {'חינוך מיוחד' : ['https://drive.google.com/drive/folders/1-56htXA4HzhRL8xrbXjhQgx-WehMbiLp?usp=sharing','חינוך מיוחד']},
          {'ייעוץ חינוכי' : ['https://drive.google.com/drive/folders/0B9x7Dd2wWPi2Qm4zMGp3Ni1TaE0?fbclid=IwAR0o6YrZvSXlHv5yjgzAKa1KBzOgERLoSNG5ZYlmBpPyH9bB2zLUCC5l0PI','ייעוץ חינוכי']},
          {'תקשורת' : ['https://drive.google.com/drive/folders/1ouPjE8GLAVwc0dhaybpohAwyclf2JXRx','תקשורת 1']},
          {'תקשורת' : ['https://drive.google.com/drive/u/0/folders/0B5mMxEy1eSFgdWtLNHlEUEFENE0?fbclid=IwAR2h51LXNoQ20i9hQIB89InkMVXb5RLjTM4ShhD3LzhQupsHVYhdCR7lwF4','תקשורת 2']},
          {'קרימינולוגיה' : ['https://drive.google.com/folderview?id=10n9Pe3WAWfbEo9lquNZpQ9wEVj3meqfe','קרימינולוגיה']},
          {'מדעי המדינה' : ['https://drive.google.com/open?id=0B5mMxEy1eSFgcmRRZk5ibXY2Q28','מדעי המדינה']},
          {'פסיכולוגיה' : ['https://drive.google.com/drive/folders/0B9Bw7evqL0IfRjN6SHRBbjYtRlE?fbclid=IwAR30nGqxz8qwxJGrO8YwKu4AIx1AVwXvO0706lU6AeCxVkmK-ibg4hxdhOY','פסיכולוגיה']},
          {'סוציולוגיה תואר שני' : ['https://drive.google.com/drive/folders/0B-pobUMm21fuNnQ3aWhLQ2NZMlU?fbclid=IwAR3W-Sf-UwTc0cFF9FY6Ug3geaDeET0Fh7cX7sj60r5CSCixM_hQc0yHiQQ','סוציולוגיה תואר שני']},
          {'מדעי ההתנהגות' : ['https://drive.google.com/drive/folders/0B2rryOQgy6xQZjk3TnhlN1BDUzQ?fbclid=IwAR1b4muso02TtL8KrYhJr9hVUtWHme-eiUzEtKJv7I-wsSLGRR2Bibq-PS8','מדעי ההתנהגות']},
          {'כלכלה/ חשבונאות' : ['https://drive.google.com/folderview?id=0B4HbQ-uGcp8pamphaGktN1pEdWM','כלכלה וחשבונאות שנה א']},
          {'כלכלה/ חשבונאות' : ['https://drive.google.com/drive/folders/1RoYCB1AyNtTVaa_PqfqhApBrkwBo-k0D?usp=sharing_eil&ts=5d7fe5d7','כלכלה שנה ב']},
          {'כלכלה/ חשבונאות' : ['https://drive.google.com/drive/u/0/folders/0B2WLXHPwOBcZR3lGYnlzOUtpcGc','כלכלה וחשבונאות']},
          {'לוגיסטיקה' : ['https://drive.google.com/drive/folders/0B_JrEH7Cw9LlflpRSVFBNExqeTlkcUsxR0pxcmNEVFQzaFZhb3NWZWUwQklDYy16Zlp2UU0','לוגיסטיקה שנה א']},
          {'לוגיסטיקה' : ['https://drive.google.com/drive/folders/0B_JrEH7Cw9LlflNBeTI0d0dVTDFKQWFGcmhNRTQ2UTl4R0x6YmRuaEFFZTBvVFpNYmdVOFE','לוגיסטיקה שנה ב']},
          {'לוגיסטיקה' : ['https://drive.google.com/drive/folders/0ByA_LUuriyK_VWJoal9mRkw1S00','המחלקה לניהול מסלול לוגיסטיקה']},
          {'לוגיסטיקה' : ['https://drive.google.com/folderview?id=0B8qqUnNPcHylbG5fRHQ2TlUtM1U','ניהול לוגיסטיקה וטכנולוגיה']},  
          {'סוציולוגיה ואנתרופולוגיה תל אביב' : ['https://drive.google.com/drive/folders/1suRBvN2jOWGjc-p9byI_Ws43RAKLiQfm?fbclid=IwAR2anBEvAihKESwZJJZaCzRONR_Xm_BKjqTPh4JlZ2latSvfMcKqhl4z6q4','סוציולוגיה ואנתרופולוגיה תל אביב']},
          {'חינוך בן גוריון' : ['https://drive.google.com/drive/u/0/folders/1lYVAoOMB7ZJY8uAWCFZ6Zt-Op4gxX7ml?fbclid=IwAR0qOW3Ed2dEtjnLDNdooFv18d5JtXMnZFxciHb39LIe_pPO7z18eI0Bdo8','חינוך בן גוריון']},
        ];


        interdisciplinary_studies_degrees_list.forEach((Map<String, List <String>> interdisciplinary_studies_degrees_list) async {
        final Map<String, dynamic> category = {
          'degree': interdisciplinary_studies_degrees_list.keys.toList()[0],
          'url':interdisciplinary_studies_degrees_list.values.toList()[0][0],
          'name':interdisciplinary_studies_degrees_list.values.toList()[0][1],
          };
        print(category);
          try {
          print('1');
          final http.Response response = await http.post(
              databaseURL + '/interdisciplinaryStudies.json',
              body: json.encode(category));

          if (response.statusCode != 200 && response.statusCode != 201) {
            print('2');
            return false;
          }
          print('3');
          return true;
        } catch (error) {
          print('4');
          return false;
        }
      });
    }
      