//
//  Constants.h
//  DemoPepper
//
//  Created by OA-Promotion-Center on 2016/07/28.
//  Copyright © 2016 OA-Promotion-Center. All rights reserved.
//

typedef enum {
    stt_ok              = 1,  // OK
    stt_ng              = 2,  // NG
    stt_not_ext         = 3,  // 存在しないステータス
    stt_err_proc        = 4,  // 内部処理エラー
    stt_pepp_end        = 5,  // Pepper終了
    stt_pepp_rest       = 6,  // Pepper起動
}stt_code;

typedef enum {
    sc_chk_sock         = 10, // ソケットをチェック
    sc_chk_que          = 20, // 問診データ(ステータス要求)
    sc_chk_org          = 22, // 組織データ(ステータス要求)
    sc_req_dt_que       = 30, // 問診データ要求(ＤＢデータ送受信)
    sc_req_dt_org       = 32, // 組織データ要求(ＤＢデータ送受信)
    sc_noti_wait        = 40, // Pepper待機中(知らせるための通信)
    sc_noti_appr        = 41, // Pepper人物接近中(知らせるための通信)
    sc_noti_cons        = 42, // Pepper経営相談中(知らせるための通信)
    sc_noti_recp        = 43, // Pepper受付中(知らせるための通信)
    sc_req_appo         = 50, // アポありコール要求(アポありコール時)
    sc_req_no_appo      = 51, // アポなしコール要求(アポなしコール時)
    sc_ans_inter        = 60, // 現在問診状況(経営相談状況チェック)
    sc_all_ans_inter    = 61  // 問診の結果をもらう。
}sc_req_code;

typedef enum {
    ss_res_chk_sock     = 11, // ソケットをチェック(ステータス応答)
    ss_res_chk_que      = 21, // 問診データ(ステータス応答)
    ss_res_chk_org      = 23, // 組織データ(ステータス応答)
    ss_res_dt_que       = 31, // 問診データ(ＤＢデータ応答)
    ss_res_dt_org       = 33, // 組織データ(ＤＢデータ応答)
    ss_res_call_ok      = 52, // コールが終了した場合、コール終了ステータスコードを返す
    ss_setup_volume     = 72, // ペッパー音を設定
}ss_res_code;

typedef enum {
    detect_people       = 1,
    enter_question      = 2,
    call_has_appoint    = 3,
    call_no_appoint     = 4
}alarm_type;

typedef enum {
    api_login           = 1,
    api_chk_get_org     = 2,
    api_chk_get_que     = 3,
}aws_api_type;

//typedef enum {
//    sock_res_01 = 1,    // ステータス応答
//    sock_res_02 = 2     // 再生秒数
//}sock_res_code;         // 応答コード
//
//typedef enum {
//    stt_unknow   = 0,   // 検索
//    stt_waiting  = 1,   // 待機中
//    stt_prepare  = 101, // 再生準備
//    stt_working  = 102, // 再生中
//    stt_finish   = 103, // 再生終了
//    stt_error    = 999  // エラー
//}status_code;           // 現在の状態
//
//typedef enum {
//    cmd_status      = 1, // ステータス要求
//    cmd_wait        = 2, // 待機命令
//    cmd_prepare     = 3, // シナリオ再生準備
//    cmd_start       = 4, // シナリオ再生
//    cmd_volume      = 96,// Pepper音量
//    cmd_close_app   = 97,// Pepperアプリ終了
//    cmd_reset       = 98,// Pepper再起動
//    cmd_finish      = 99 // Pepper終了
//}command_code;           // 命令コードー覧

typedef enum {
    error_code_1    = 1, // JSONのパーズを失敗しました。
    error_code_2    = 2, // パラメータを間違います。
    error_code_3    = 3, // この命令がありません。
    error_code_4    = 4, // シナリオが読み取れませんでした。
    error_code_5    = 5, // シナリオが有りません。
    error_code_6    = 6  // ペッパーのボリュームを変更ができません。
}error_code;

typedef enum{
    main_vc         = 0,
    waiting_vc      = 1,
    reception_vc    = 2,
    approach_vc     = 3,
    interview_vc    = 4,
    appointment_vc  = 5,
    no_appointment_vc = 6,
} pepper_vc; // current view of pepper tablet

#define kHeightBtnRightNavi                     40.0
#define kWidthBtnRightNavi                      40.0

#define kHeightLoginScreenTrans                 100.0f

#define kUserAlarmIdDetectPeople                @"kUserAlarmIdDetectPeople"
#define kUserAlarmIdEnterQuestion               @"kUserAlarmIdEnterQuestion"
#define kUserAlarmIdCallHasAppo                 @"kUserAlarmIdCallHasAppo"
#define kUserAlarmIdCallNoAppo                  @"kUserAlarmIdCallNoAppo"

#define kDefaultAwsApiUrl                       @"kDefaultAwsApiUrl"
#define kDefaultAwsUserId                       @"kDefaultAwsUserId"
#define kDefaultAwsUserPw                       @"kDefaultAwsUserPw"
#define kDefaultSocketServerPort                @"kDefaultSocketServerPort"
#define kDefaultPepperVolume                    @"kDefaultPepperVolume"

#define kUserInfoAwsApiToken                    @"kUserInfoAwsApiToken"
#define kUserInfoBlockForSetup                  @"kUserInfoBlockForSetup" // 1 : YES, 0 : NO
#define kUserInfoBumonIdAtPepper                @"kUserInfoBumonIdAtPepper"
#define kUserInfoShainIdAtPepper                @"kUserInfoShainIdAtPepper"
#define kUserInfoQuestionIdAtPepper             @"kUserInfoQuestionIdAtPepper"
#define kUserInfoAnswerIdAtPepper               @"kUserInfoAnswerIdAtPepper"
#define kUserInfoCurrentViewAtPepper            @"kUserInfoCurrentViewAtPepper"

#define kImgBtnSetting                          @"btn_setting_green.png"
#define kImgBtnAdd                              @"btn_add.png"
#define kImgBtnPlay                             @"btn_play.png"
#define kImgBtnPause                            @"btn_pause.png"
#define kImgBtnBack                             @"btn_back.png"
#define kImgBtnRefresh                          @"btn_refresh.png"
#define kImgBtnEdit                             @"btn_edit.png"
#define kImgBtnCancel                           @"btn_cancel.png"

#define kSoundButton                            @"btn_sound.wav"


#define kNibLoginVC                             @"LoginVC"
#define kNibMainVC                              @"MainVC"
#define kNibWaitingVC                           @"WaitingVC"
#define kNibApproachVC                          @"ApproachVC"
#define kNibReceptionVC                         @"ReceptionVC"
#define kNibInterviewVC                         @"InterviewVC"
#define kNibAppointmentVC                       @"AppointmentVC"
#define kNibNoAppointmentVC                     @"NoAppointmentVC"
#define kNibSettingVC                           @"SettingVC"
#define kNibErrorView                           @"ErrorView"

#define JSON_KEY_STT_CODE                       @"StatusCode"
#define JSON_KEY_UPDATE_TIME                    @"UpdateTime"
#define JSON_KEY_DATA                           @"Data"
#define JSON_KEY_QUESTION                       @"Question"
#define JSON_KEY_ANSWER                         @"Answer"
#define JSON_KEY_IMAGE                          @"Image"
#define JSON_KEY_BUMON                          @"Bumon"
#define JSON_KEY_SHAIN                          @"Shain"
#define JSON_KEY_BUMON_ID                       @"BumonID"
#define JSON_KEY_SHAIN_ID                       @"ShainID"
#define JSON_KEY_QUESTION_ID                    @"QuestionID"
#define JSON_KEY_ANSWER_ID                      @"AnswerID"
#define JSON_KEY_VOLUME                         @"Volume"

#define JSON_AWS_ANSWER_LIST                    @"answer_list"
#define JSON_AWS_QUESTION_ID                    @"question_id"
#define JSON_AWS_ANSWER_ID                      @"answer_id"

#define JSON_KEY_ORDER_DATA                     @"OrderData"
#define JSON_KEY_SCENARIO_CODE                  @"ScenarioCode"
#define JSON_KEY_SCENARIO_NAME                  @"ScenarioName"
#define JSON_KEY_SCENARIO_DESCRIPTION           @"ScenarioDescription"
#define JSON_KEY_PEPPER_NUM                     @"PepperNum"
#define JSON_KEY_ACTION_DATA_NUM1               @"ActionDataNum1"
#define JSON_KEY_ACTION_DATA_NUM2               @"ActionDataNum2"
#define JSON_KEY_ACTION_DATA_1                  @"ActionData1"
#define JSON_KEY_ACTION_DATA_2                  @"ActionData2"
#define JSON_KEY_START_TIME                     @"StartTime"
#define JSON_KEY_ACTION_CODE                    @"ActionCode"
#define JSON_KEY_ACTION_DATA                    @"ActionData"
#define JSON_KEY_RESPONSE_NO                    @"ResponseNo"
#define JSON_KEY_PEPPER_VOLUME                  @"PepperVolume"
#define JSON_KEY_STATUS                         @"Status"
#define JSON_KEY_CURRENT_TIME                   @"CurrentTime"
#define JSON_KEY_ERROR_CODE                     @"ErrorCode"
#define JSON_KEY_ERROR_MESSAGE                  @"ErrorMessage"

#define K_API_NOTIFI_1                          @"データベースとの通信に失敗しました。"
#define K_API_NOTIFI_2                          @"データベースとの接続に失敗しました。"
#define K_API_NOTIFI_3                          @"パラメータがありません。"
#define K_API_NOTIFI_4                          @"サーバーAPIの呼び出しに失敗しました。"
#define K_API_NOTIFI_5                          @"サーバーAPIでエラーが発生しました。"
#define K_API_NOTIFI_6                          @"アプリの初期データが存在していません。"
#define K_API_NOTIFI_7                          @"ユーザーIDまたはパスワードに誤りがあります。"
#define K_API_NOTIFI_8                          @"ユーザーIDまたはパスワードに誤りがあります。"
#define K_API_NOTIFI_9                          @"他のデバイスで既にこのユーザーIDは利用中です。全体デバイスでログアウトする？"
#define K_API_NOTIFI_10                         @"ログアウトができません。ログイン画面を戻る？"
#define K_API_NOTIFI_11                         @"ログインされていません。"
#define K_API_MSG_NOTIFI_1001                   @"サーバーとの通信がタイムアウトしました。"
#define K_API_MSG_NOTIFI_1011                   @"URLが不正です。"
#define K_API_MSG_NOTIFI_1002                   @"URLが不明です。"


#define kAlertMsgTitle                          @"メッセージ"
#define kAlertMsgError                          @"エラー"
#define kAlertMsgLogin                          @"ログイン中・・・"
#define kAlertMsgBtnOk                          @"はい"
#define kAlertMsgBtnCancel                      @"いいえ"
#define kAlertMsgDeleteItem                     @"削除しますか？"
#define kAlertMsgStopScenario                   @"シナリオ再生を止めますか？"
#define kAlertMsgPreventAction                  @"この機能を使用できません。"
#define kAlertMsgRunOtherScenario               @"シナリオを再生しているPepperがあります。再生しているシナリオを停止して、現在のシナリオを再生しますか？"
#define kAlertMsgLastestSocketError             @"のソケットの接続に失敗しました。"
#define kAlertMsgPleaseSetupSocketPort          @"ソケットの設定に失敗しました。設定画面で設置してください。"
#define kAlertMsgSocketServerListening          @"ソケットの設定ができました。"
#define kAlertMsgCannotRunOnSimulator           @"シミュレータで実行するができません！"

#define kAlertMsgNotFoundAwsApi                 @"AWSアドレスがありません。"
#define kAlertMsgNotInputUserId                 @"ログインIDは必須です。"
#define kAlertMsgNotInputPassword               @"パスワードは必須です。"
#define kAlertMsgNotToken                       @"トークンがありません。"
#define kAlertMsgDontChangeUpdateTime           @"AWSのデータに変更がありませんでした。"

#define kAlertMsgServerMainten                  @"現在メンテナンス中です、しばらく経ってから再接続してください"
#define kAlertMsgServerSystemError              @"サーバエラーです、サポートへ連絡してください"
#define kAlertMsgServerInvalidRequest           @"通信データエラーです、サポートへ連絡してください"

#define kMsgCheckStatusOrganization             @"組織構成データ更新日時をチェック中・・・"
#define kMsgCheckStatusQuestion                 @"問診データ更新日時をチェック中・・・"
#define kMsgUpdateOrganization                  @"組織構成データを更新中・・・"
#define kMsgUpdateQuestion                      @"問診データを更新中・・・"

#define kAlertMsgServerError1                   @"JSONのパーズを失敗しました。"
#define kAlertMsgServerError2                   @"パラメータを間違います。"
#define kAlertMsgServerError3                   @"この命令がありません。"
#define kAlertMsgServerError4                   @"シナリオが読み取れませんでした。"
#define kAlertMsgServerError5                   @"シナリオが有りません。"
#define kAlertMsgServerError6                   @"ペッパーのボリュームを変更ができません。"

#define kStreamMsgErrorOccurred                 @"ペッパーとの接続に失敗しました"
#define kStreamMsgEndEncountered                @"ペッパーのソケットの接続に失敗しました"

#define kTxtPepperStatusUnknow                  @"検索"
#define kTxtPepperStatusWaiting                 @"待機中"
#define kTxtPepperStatusPrepare                 @"再生準備"
#define kTxtPepperStatusWorking                 @"再生中"
#define kTxtPepperStatusFinish                  @"再生終了"
#define kTxtPepperStatusError                   @"エラー"






