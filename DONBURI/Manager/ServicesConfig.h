//
//  ServicesConfig.h
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/26.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

typedef enum{
    api_ok = 200,
    api_err_invalid = 400,
    api_err_login_info = 401,
    api_err_not_exist = 404,
    api_err_system    = 500,
    api_err_system_mainten = 503,
    api_parser_error = 1001,
    api_connect_failed = -1001
} status_code;

#define kApiMethodId                @"methodId"
#define kApiUserToken               @"token"

#define kApiUrlLogin                @"login.json"
#define kApiUrlInterviewUpdateTime  @"interview_updatetime.json"
#define kApiUrlSoshikiUpdateTime    @"soshiki_updatetime.json"
#define kApiUrlInterviewData        @"interview_data.json"
#define kApiUrlSoshikiData          @"soshiki_data.json"

#define kApiUrlUpdateResult         @"input_monshin_result.json"

#define kApiUserID              @"login_id"
#define kApiUserPass            @"login_password"
#define kApiJsonData            @"jsonData"

#define kApiResponseData        @"ret"
#define kApiStatus              @"status_code"
