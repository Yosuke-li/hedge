import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:hedge_manager/helper/dio/interceptor.dart';
import 'package:hedge_manager/helper/global/api.dart';
import 'package:hedge_manager/helper/log_utils.dart';
import 'package:hedge_manager/helper/store.dart';

import 'api_exception.dart';

class Request {
  static String baseUrl = ApiUrl.dioUrl;

  // 配置 Dio 实例
  static final BaseOptions _options = BaseOptions(
      connectTimeout: 10000,
      receiveTimeout: 3000,
      contentType: 'application/json',
      responseType: ResponseType.json);

  static final BaseOptions _loginOptions = BaseOptions(
      connectTimeout: 10000,
      receiveTimeout: 3000,
      contentType: 'application/x-www-form-urlencoded',
      responseType: ResponseType.plain);

  // 创建 Dio 实例
  static final Dio _dio = Dio(_options);

  static onChangeUrl() {
    baseUrl = ApiUrl.dioUrl;
  }

  // _request 是核心函数，所有的请求都会走这里
  static Future<Response> _request<T>(String path,
      {String? method, Map<String, dynamic>? params, data}) async {
    //选择服务器
    _dio.options.baseUrl = baseUrl;
    //dio拦截器
    // _dio.interceptors.add(DioInterceptor());
    Log.info(baseUrl);

    // restful 请求处理
    final Map<String, dynamic> headers = <String, dynamic>{};

    //一般情况下，登陆后修改cookie。
    final String? cookieJson = LocateStorage.getStringWithExpire('cookie');
    if (cookieJson != null && cookieJson.isNotEmpty == true) {
      headers['Cookie'] = cookieJson;
      _options.headers = headers;
    }

    const String token = '';
    if (token.isNotEmpty == true) {
      headers['Authorization'] = 'Bearer ' + token;
      _options.headers = headers;
    }

    //检查抓包
    // if (Global.isFiddle == true) {
    //   setProxy();
    // }

    try {
      final Response response = await _dio.request(path,
          data: data,
          options: Options(method: method, headers: headers),
          queryParameters: params);

      if (response.statusCode == 200) {
        return response;
      } else {
        _handleHttpError(response.statusCode!);
        throw ApiException(response.statusCode!, response.statusMessage!);
      }
    } on DioError catch (e, s) {
      throw ApiException(e.response?.statusCode ?? 400, _dioError(e));
    } catch (e, s) {
      throw ApiException(0, e.toString());
    }
  }

  // 处理 Dio 异常
  static String _dioError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        return '网络连接超时，请检查网络设置';
        break;
      case DioErrorType.receiveTimeout:
        return '服务器异常，请稍后重试！';
        break;
      case DioErrorType.sendTimeout:
        return '网络连接超时，请检查网络设置';
        break;
      case DioErrorType.response:
        return '服务器异常，请稍后重试！';
        break;
      case DioErrorType.cancel:
        return '请求已被取消，请重新请求';
        break;
      default:
        return error.message;
    }
  }

  //设置抓包
  static void setProxy() {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.findProxy = (Uri url) {
        return 'PROXY :8888';
      };
      //抓Https包设置
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
  }

  // 处理 Http 错误码
  static void _handleHttpError(int errorCode) {
    String message;
    switch (errorCode) {
      case 400:
        message = '请求语法错误';
        break;
      case 401:
        message = '未授权，请登录';
        break;
      case 403:
        message = '拒绝访问';
        break;
      case 404:
        message = '请求出错';
        break;
      case 408:
        message = '请求超时';
        break;
      case 500:
        message = '服务器异常';
        break;
      case 501:
        message = '服务未实现';
        break;
      case 502:
        message = '网关错误';
        break;
      case 503:
        message = '服务不可用';
        break;
      case 504:
        message = '网关超时';
        break;
      case 505:
        message = 'HTTP版本不受支持';
        break;
      default:
        message = '请求失败，错误码：$errorCode';
    }
  }

  static Future<Response> get<T>(String path, {Map<String, dynamic>? params}) {
    _dio.options = _options;
    return _request(path, method: 'get', params: params);
  }

  static Future<Response> post<T>(String path, {data}) {
    _dio.options = _options;
    return _request(path, method: 'post', data: data);
  }

  static Future<Response> login<T>({Map<String, dynamic>? params}) {
    LocateStorage.clean(key: 'cookie');
    _dio.options = _loginOptions;
    _dio.options.headers['Authorization'] = 'Basic ' +
        base64Encode(
            utf8.encode('admin:admin'));
    return _request('/oauth/token', method: 'post', data: params);
  }

  static Future<Response> downloadFile(String resUrl, String savePath,
      void Function(int loaded, int total) callBack) async {
    return await _dio.download(resUrl, savePath,
        onReceiveProgress: (int loaded, int total) {
      callBack.call(loaded, total);
    });
  }
}
