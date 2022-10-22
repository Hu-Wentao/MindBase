package com.mind.base.db;

import io.appwrite.Client;
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
class AppWriteConfig {
    @Bean("appwriteClient")
    fun appWriteClient(@Qualifier("appWriteProperties") appWriteProperties:AppWriteProperties):Client {
        return Client().setEndpoint(appWriteProperties.endpoint)
            .setKey(appWriteProperties.key)
            .setProject(appWriteProperties.project)
            .setSelfSigned(appWriteProperties.selfSigned)
    }
    @ConfigurationProperties("appwrite")
    @Bean("appWriteProperties")
    fun appWriteProperties():AppWriteProperties{
        return AppWriteProperties()
    }
}
