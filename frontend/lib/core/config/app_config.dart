AppConfig appConfig = AppConfig.prod();

enum Flavor { dev, prod }

class AppConfig {
  final String baseUrl;
  final Flavor flavor;

  AppConfig.dev() : flavor = .dev, baseUrl = 'https://api-dev-betterway.leeeeeoy.xyz';

  AppConfig.prod() : flavor = .prod, baseUrl = 'https://api-betterway.leeeeeoy.xyz';
}
