import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:yoga_student_app/common/colors.dart';
import 'package:get/get.dart';
import 'package:yoga_student_app/pages/payment_method_modules/payment_method_model.dart';
import 'package:yoga_student_app/pages/payment_method_modules/upload_receipt_page.dart';
import 'package:yoga_student_app/services/address.dart';
import 'package:yoga_student_app/services/dio_manager.dart';
import 'package:yoga_student_app/utils/hex_color.dart';
import 'charge_code_model.dart';


class PayMethodPage extends StatefulWidget {


  int type;

  PayMethodPage(this.type,{Key? key}) : super(key: key);

  @override
  State<PayMethodPage> createState() => _PayMethodPageState();
}

class _PayMethodPageState extends State<PayMethodPage> {

  PaymentMethodModel? paymentMethodModel;

  TextEditingController codeTextEditingController = TextEditingController();

  requestDataWithChargeType()async{
    var params = {
      'method':'charge.type',
    };
    var json = await DioManager().kkRequest(Address.hostAuth,bodyParams:params);

    PaymentMethodModel model = PaymentMethodModel.fromJson(json);

    paymentMethodModel = model;

    setState(() {

    });
  }
  /// 获取优惠方式
  ChargeCodeModel? chargeCodeModel;
  requestDataWithChargeCode(var code)async{
    var params = {
      'method':'charge.code',
      'code':code,
    };
    var json = await DioManager().kkRequest(Address.hostAuth,bodyParams:params);

    ChargeCodeModel model = ChargeCodeModel.fromJson(json);


    if(model.code == 200){
      chargeCodeModel = model;
      BotToast.showText(text: '已使用優惠碼');
    }else{
      BotToast.showText(text: model.message!);
      return;
    }

    if(model.data!.useNum==0){
      chargeCodeModel = model;
    }else if(model.data!.useNum!>0&&model.data!.usedNum! >= model.data!.useNum!){
      BotToast.showText(text: '優惠券不可用');
    }


    setState(() {

    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestDataWithChargeType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        title: const Text('付款方式'),
      ),
      body: SafeArea(
        child:Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColor.themeColor,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(20)),
              ),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(18))
                      ),
                      width: Get.width-100,
                      height: 35,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 15),
                      child: TextField(
                        controller: codeTextEditingController,
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: '輸入優惠碼',
                          hintStyle: TextStyle(color: AppColor.themeTextColor,fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  TextButton(onPressed: (){
                    print(codeTextEditingController.text);
                    if(codeTextEditingController.text.isEmpty){
                      BotToast.showText(text: '請輸入優惠碼');
                      return;
                    }
                    requestDataWithChargeCode(codeTextEditingController.text);
                  }, child: Text('使用',style: TextStyle(color: AppColor.themeTextColor),))
                ],
              ),
            ),

            Expanded(child: CustomScrollView(
              slivers: [
                SliverList(delegate: _mySliverChildBuilderDelegate()),

                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 15,),
                      Center(
                        child: Text('如欲使用Payme付款可與客服聯繫',style: TextStyle(color: AppColor.themeTextColor),),
                      ),
                      // Center(
                      //   child: Container(
                      //       margin: const EdgeInsets.only(top: 15),
                      //       width: Get.width-30,
                      //       child: Row(
                      //         children: [
                      //           Container(
                      //             height: 24,
                      //             width: 5,
                      //             color: HexColor('#343679'),
                      //           ),
                      //           const SizedBox(width: 3,),
                      //           Text('退款政策',style: TextStyle(fontSize: 21,color: AppColor.themeTextColor),),
                      //         ],
                      //       )
                      //   ),
                      // ),
                      Container(

                          margin: const EdgeInsets.only(top: 15,left: 35,right: 35),
                          child: Column(
                            children: [
                              SelectableText('''
請學員細閱以下提示：

1. 學員已繳付的所有費用，不設退款或轉讓，不接受任何理由將課堂延期。MeMoYoga保留一切權利。如患上新冠病毒或任何病患，請出示有效醫生證明，否則一概不可取消課堂。

2. 開課前24小時內不能取消課堂，如未能出席將課堂扣除。

3. 學員身體如有傷患/舊患/懷孕等特別情況，需主動通知老師及學員已明白及同意MeMoYoga其免責機制。

4. 請於開課前5-10分鐘前到達； 如遲到多於10分鐘，有機會被拒上課，以免影響其他學員練習。

5. MeMoYoga有提供消毒物品，請學員於落堂後將瑜伽用具消毒。並請勿踐踏其他人學員的瑜伽蓆，以尊重瑜伽精神。

6. 特殊情況下的上堂安排：如果上堂前2小時，懸掛8號風球或以上或者黑暴雨警告訊號生效，則會停課，已預約課堂可改期。

7. 如有任何問題，可於辦公時間（11:00-21:00）Whatsapp: 5597 8331
                              
                              
                  ''',style: TextStyle(fontSize: 12,color: AppColor.themeTextColor),),
                            ],
                          )
                      ),
                    ],
                  ),
                )
              ],
            )),
          ],
        ),
      )
    );
  }
  SliverChildBuilderDelegate _mySliverChildBuilderDelegate(){
    return SliverChildBuilderDelegate((context, index) {

      PaymentMethodList model = paymentMethodModel!.data!.list![index];
      return model.isShareWallet==widget.type?GestureDetector(
        onTap: (){

          if(chargeCodeModel==null){
            Get.to(UpLoadReceiptPage(model.id!,codeTextEditingController.text,double.parse(model.amount!)));
          }else{
            var amount = double.parse(model.amount!);
            var codeAmount = double.parse(chargeCodeModel!.data!.cash!);
            print(amount - codeAmount);
            Get.to(UpLoadReceiptPage(model.id!,codeTextEditingController.text,amount - codeAmount));
          }

          // Get.to(ReceiptPage());
        },
        child:Center(
          child: Container(
            width: Get.width-20,
            margin: const EdgeInsets.only(top: 15),
            height: 70,
            padding: const EdgeInsets.only(left: 15,right: 5),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(
                    width: 0.9,
                    color: AppColor.themeColor
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                    children: [
                     Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('${model.name}',style: TextStyle(fontSize: 20,color: AppColor.themeTextColor),),
                         // model.isShareWallet==0?Text('正常钱包充值',style: TextStyle(fontSize: 12,color: AppColor.themeTextColor),):
                         // Text('共享錢包充值',style: TextStyle(fontSize: 12,color: AppColor.themeTextColor),),
                         Row(children: [
                           Image.asset('images/ic_mine_jinbi.png',width: 25,height: 25,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text('${model.gold}'),
                               chargeCodeModel?.data?.gold==null? const SizedBox():
                               Text(' +${chargeCodeModel?.data?.gold}',style: const TextStyle(color: Colors.red),)
                             ],
                           ),
                         ],)
                       ],
                     ),

                    ],
                  ),

                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('HK\$${model.amount}',style: TextStyle(fontSize: 20,color: AppColor.themeTextColor),),
                        chargeCodeModel?.data?.cash==null? const SizedBox():
                        Text('-HK\$${chargeCodeModel?.data?.cash}',style: const TextStyle(
                          color:Colors.green
                        ),)

                      ],
                    ),
                    Icon(Icons.arrow_forward_ios,color: AppColor.themeColor,size: 15,)
                  ],
                )
              ],
            ),
          ),
        ),
      ):SizedBox();
    },childCount: paymentMethodModel?.data?.list?.length??0);
  }

}
