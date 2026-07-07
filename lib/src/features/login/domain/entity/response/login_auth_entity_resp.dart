class LoginAuthEntityResp {
  final String? token;
  final String? context;
  final String? error;
  final MetaEntityResp? meta;

  LoginAuthEntityResp({
    this.token,
    this.context,
    this.error,
    this.meta,
  });
}

class MetaEntityResp {
  final String? poweredBy;
  final String? docsUrl;
  final String? upgradeUrl;
  final String? exampleUrl;
  final String? variant;
  final String? message;
  final CtaEntityResp? cta;

  MetaEntityResp({
    this.poweredBy,
    this.docsUrl,
    this.upgradeUrl,
    this.exampleUrl,
    this.variant,
    this.message,
    this.cta,
  });
}

class CtaEntityResp {
  final String? label;
  final String? url;

  CtaEntityResp({
    this.label,
    this.url,
  });
}