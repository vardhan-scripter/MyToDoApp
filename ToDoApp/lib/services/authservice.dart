
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todotask/model/apiresponse.dart';
import 'package:todotask/model/getTaskData.dart';
import 'package:todotask/model/insertTaskData.dart';
import 'package:todotask/utils/constants.dart';

class AuthService{
  //get shared preferences instance
  SharedPreferences _prefs;
  String token;
  //get dio instance
  Dio dio = Dio();
   Future<ApiResponse<bool>>createAccountWithEmailAndPassword({name,email,password}) async{
     Map<String,dynamic> data = {
       "name":name,
       'email':email,
       'password':password,
     };
     try{
       Response response = await dio.post('$URL/auth/register',data:(data));
       Map<String,dynamic> jsonData;
       //check for the 200 response from the api
       if(response.statusCode == 200){
         ApiResponse apiResponse = ApiResponse();
         jsonData = response.data;
         //check the condition for success = true from api then
         if(jsonData['success']){
           return ApiResponse<bool>(
               data: jsonData['success'],
               message: jsonData['message']
           );
         }else{
           //if it is success is false then
           return ApiResponse<bool>(
               data: jsonData['success'],
               message: jsonData['message']
           );
         }
       }else{
         // in the case of response code not 200
         return ApiResponse<bool>(
             data:jsonData['success'],
             error: true,
             message: jsonData['message']
         );
       }
     }catch(exception){
       //in the case of exception
       return ApiResponse<bool>(
         data: false,
         error: true,
         message: '${exception.toString()}'
       );
     }
}

  Future<ApiResponse<bool>> signInWithEmailAndPassword({email,password}) async{
    Map<String,dynamic> data = {
      'email':email,
      'password':password,
    };
    try{
      Response response = await dio.post('$URL/auth/login',data:(data));
      Map<String,dynamic> jsonData;
      if(response.statusCode == 200){
        ApiResponse apiResponse = ApiResponse();
        jsonData = response.data;
        //print(response.data.toString());
        if(jsonData['success']){
          _prefs = await SharedPreferences.getInstance();
          _prefs.setString(TOKEN_ID, jsonData['token']);
          return ApiResponse<bool>(
              data: jsonData['success'],
              message: jsonData['message']
          );
        }else{
          return ApiResponse<bool>(
              data: jsonData['success'],
              message: jsonData['message']
          );
        }
      }else{
        return ApiResponse<bool>(
            data:jsonData['success'],
            error: true,
            message: jsonData['message']
        );
      }
    }catch(exception){
      return ApiResponse<bool>(
          data: false,
          error: true,
          message: '${exception.toString()}'
      );
    }
  }
  //logic for adding newTodo
  Future<ApiResponse<bool>> insertNewTodo({InsertTaskData taskData}) async{
    try{
      _prefs = await SharedPreferences.getInstance();
      Response response = await dio.post('$URL/item/addItem',data: taskData.toJson(),options: Options(
          headers: {'Authorization':_prefs.getString(TOKEN_ID)},
          contentType: 'application/json'
      ));
      Map<String,dynamic> jsonData;
      if(response.statusCode == 200){
        jsonData = response.data;
        if(jsonData['success']){
          return ApiResponse<bool>(
              data: jsonData['success'],
              message: 'Item inserted.'
          );
        }else{
          return ApiResponse<bool>(
              data: jsonData['success'],
              message: jsonData['message']
          );
        }
      }else{
        return ApiResponse<bool>(
            data: jsonData['success'],
            message: jsonData['message']
        );
      }
    }catch(e){
      return ApiResponse<bool>(
        data: false,
        error: true,
        message: e.toString()
      );
    }
  }
  //logic for update the todoItem
  Future<ApiResponse<bool>> updateTodo({InsertTaskData taskData,String itemId}) async{
    try{
      _prefs = await SharedPreferences.getInstance();
      Response response = await dio.put('$URL/item/updateItem/$itemId',data: taskData.toJson(),options: Options(
          headers: {'Authorization':_prefs.getString(TOKEN_ID)},
          contentType: 'application/json'
      ));
      Map<String,dynamic> jsonData;
      if(response.statusCode == 200){
        jsonData = response.data;
        if(jsonData['success']){
          return ApiResponse<bool>(
              data: jsonData['success'],
              message: 'Item inserted.'
          );
        }else{
          return ApiResponse<bool>(
              data: jsonData['success'],
              message: jsonData['message']
          );
        }
      }else{
        return ApiResponse<bool>(
            data: jsonData['success'],
            message: jsonData['message']
        );
      }
    }catch(e){
      return ApiResponse<bool>(
        data: false,
        error: true,
        message: e.toString()
      );
    }
  }
   //logic for get the todoItem
  Future<ApiResponse<GetTaskData>> getTodoItem({String itemId}) async{
    try{
      _prefs = await SharedPreferences.getInstance();
      Response response = await dio.get('$URL/item/getItem/$itemId',options: Options(
          headers: {'Authorization':_prefs.getString(TOKEN_ID)},
          contentType: 'application/json'
      ));
      Map<String,dynamic> jsonData;
      if(response.statusCode == 200){
        jsonData = response.data;
        if(jsonData['success']){
          return ApiResponse<GetTaskData>(
              data: GetTaskData.fromJson(jsonData['item'][0]),
            message: jsonData['message']
          );
        }else{
          return ApiResponse<GetTaskData>(
              data: null,
              error: true,
              message: jsonData['message']
          );
        }
      }else{
        return ApiResponse<GetTaskData>(
            data: null,
            error: true,
            message: jsonData['message']
        );
      }
    }catch(e){
      return ApiResponse<GetTaskData>(
        data: null,
        error: true,
        message: e.toString()
      );
    }
  }  //logic for delete the todoItem
  Future<ApiResponse<bool>> deleteTodoItem({String itemId}) async{
    try{
      _prefs = await SharedPreferences.getInstance();
      Response response = await dio.delete('$URL/item/deleteItem/$itemId',options: Options(
          headers: {'Authorization':_prefs.getString(TOKEN_ID)},
          contentType: 'application/json'
      ));
      Map<String,dynamic> jsonData;
      if(response.statusCode == 200){
        jsonData = response.data;
        if(jsonData['success']){
          return ApiResponse<bool>(
              data: jsonData['success'],
              message: jsonData['message']
          );
        }else{
          return ApiResponse<bool>(
              data: jsonData['success'],
              error: true,
              message: jsonData['message']
          );
        }
      }else{
        return ApiResponse<bool>(
            data: jsonData['success'],
            error: true,
            message: jsonData['message']
        );
      }
    }catch(e){
      return ApiResponse<bool>(
        data: false,
        error: true,
        message: e.toString()
      );
    }
  }
  //logic for get list of todoItem
  Stream<ApiResponse<List<GetTaskData>>> getTodoListItems() async*{
    try{
      _prefs = await SharedPreferences.getInstance();
      Response response = await dio.get('$URL/item/getItems',options: Options(
          headers: {'Authorization':_prefs.getString(TOKEN_ID)},
          contentType: 'application/json'
      ));
      dynamic jsonData;
     // print("status code ${response.statusCode}");
      if(response.statusCode == 200){
        jsonData = response.data;
        List<GetTaskData> taskItems = [];
        if(jsonData['items'].length!=0){
          for(var json in jsonData['items']){
            GetTaskData taskData = GetTaskData();
            taskData = GetTaskData.fromJson(json);
            taskItems.add(taskData);
            yield ApiResponse<List<GetTaskData>>(
              data: taskItems,
              message: jsonData['message']
            );
          }
        }else{
          yield null;
        }
      }else{
        yield null;
      }
    }catch(e){
      yield null;
    }
  }


  //logic for toggle the todoItem
  Future<ApiResponse<bool>> updateToggle({String itemId}) async{
    try{
      _prefs = await SharedPreferences.getInstance();
      Response response = await dio.put('$URL/item/toggleItem/$itemId',options: Options(
          headers: {'Authorization':_prefs.getString(TOKEN_ID)},
          contentType: 'application/json'
      ));
      Map<String,dynamic> jsonData;
      if(response.statusCode == 200){
        jsonData = response.data;
        if(jsonData['success']){
          return ApiResponse<bool>(
              data: jsonData['success'],
              message: jsonData['message']
          );
        }else{
          return ApiResponse<bool>(
              data: jsonData['success'],
              message: jsonData['message']
          );
        }
      }else{
        return ApiResponse<bool>(
            data: jsonData['success'],
            message: jsonData['message']
        );
      }
    }catch(e){
      return ApiResponse<bool>(
          data: false,
          error: true,
          message: e.toString()
      );
    }
  }
 //logic for forget password
  Future<ApiResponse<bool>> forgotPasswordWithMail({String email}) async{
     Map<String,dynamic> emailData = {
       'email':email
     };
    try{
      _prefs = await SharedPreferences.getInstance();
      Response response = await dio.post('$URL/auth/forgotpassword',data: emailData);
      Map<String,dynamic> jsonData;
      if(response.statusCode == 200){
        jsonData = response.data;
        if(jsonData['success']){
          return ApiResponse<bool>(
              data: jsonData['success'],
              message: jsonData['message']
          );
        }else{
          return ApiResponse<bool>(
              data: jsonData['success'],
              message: jsonData['message']
          );
        }
      }else{
        return ApiResponse<bool>(
            data: jsonData['success'],
            message: jsonData['message']
        );
      }
    }catch(e){
      return ApiResponse<bool>(
          data: false,
          error: true,
          message: e.toString()
      );
    }
  }

  //logic for reset password
  Future<ApiResponse<bool>> resetPasswordWithMail({String email,String password,String code}) async{
    Map<String,dynamic> resetPasswordData = {
      'email':email,
      'password':password,
      'code':code
    };
    try{
      _prefs = await SharedPreferences.getInstance();
      Response response = await dio.post('$URL/auth/resetpassword',data: resetPasswordData);
      Map<String,dynamic> jsonData;
      if(response.statusCode == 200){
        jsonData = response.data;
        if(jsonData['success']){
          return ApiResponse<bool>(
              data: jsonData['success'],
              message: jsonData['message']
          );
        }else{
          return ApiResponse<bool>(
              data: jsonData['success'],
              message: jsonData['message']
          );
        }
      }else{
        return ApiResponse<bool>(
            data: jsonData['success'],
            message: jsonData['message']
        );
      }
    }catch(e){
      return ApiResponse<bool>(
          data: false,
          error: true,
          message: e.toString()
      );
    }
  }

}
