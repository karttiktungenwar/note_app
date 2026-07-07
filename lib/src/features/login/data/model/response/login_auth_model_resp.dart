import 'package:noteapp/src/features/login/domain/entity/response/login_auth_entity_resp.dart';

class LoginAuthModelResp extends LoginAuthEntityResp {
  LoginAuthModelResp({
    super.token,
    super.context,
    super.error,
    super.meta,
  });

  factory LoginAuthModelResp.fromJson(Map<String, dynamic> json) {
    return LoginAuthModelResp(
      token: json['token'] as String?,
      context: json['context'] as String?,
      error: json['error'] as String?,
      meta: json['_meta'] != null
          ? MetaModelResp.fromJson(json['_meta'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'context': context,
      'error': error,
      '_meta': meta is MetaModelResp ? (meta as MetaModelResp).toJson() : null,
    };
  }

  LoginAuthEntityResp toEntity() {
    return LoginAuthEntityResp(
      token: token,
      context: context,
      error: error,
      meta: meta != null ? (meta as MetaModelResp).toEntity() : null,
    );
  }
}

class MetaModelResp extends MetaEntityResp {
  MetaModelResp({
    super.poweredBy,
    super.docsUrl,
    super.upgradeUrl,
    super.exampleUrl,
    super.variant,
    super.message,
    super.cta,
  });

  factory MetaModelResp.fromJson(Map<String, dynamic> json) {
    return MetaModelResp(
      poweredBy: json['powered_by'] as String?,
      docsUrl: json['docs_url'] as String?,
      upgradeUrl: json['upgrade_url'] as String?,
      exampleUrl: json['example_url'] as String?,
      variant: json['variant'] as String?,
      message: json['message'] as String?,
      cta: json['cta'] != null
          ? CtaModelResp.fromJson(json['cta'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'powered_by': poweredBy,
      'docs_url': docsUrl,
      'upgrade_url': upgradeUrl,
      'example_url': exampleUrl,
      'variant': variant,
      'message': message,
      'cta': cta is CtaModelResp ? (cta as CtaModelResp).toJson() : null,
    };
  }

  MetaEntityResp toEntity() {
    return MetaEntityResp(
      poweredBy: poweredBy,
      docsUrl: docsUrl,
      upgradeUrl: upgradeUrl,
      exampleUrl: exampleUrl,
      variant: variant,
      message: message,
      cta: cta != null ? (cta as CtaModelResp).toEntity() : null,
    );
  }
}

class CtaModelResp extends CtaEntityResp {
  CtaModelResp({
    super.label,
    super.url,
  });

  factory CtaModelResp.fromJson(Map<String, dynamic> json) {
    return CtaModelResp(
      label: json['label'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'url': url,
    };
  }

  CtaEntityResp toEntity() {
    return CtaEntityResp(
      label: label,
      url: url,
    );
  }
}