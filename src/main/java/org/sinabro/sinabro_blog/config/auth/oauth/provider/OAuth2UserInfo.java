package org.sinabro.sinabro_blog.config.auth.oauth.provider;

public interface OAuth2UserInfo {
    String getProviderId();
    String getProvider();
    String getName();
    String getEmail();
}
