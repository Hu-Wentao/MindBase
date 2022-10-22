package com.mind.base.db

import com.alibaba.druid.spring.boot.autoconfigure.DruidDataSourceBuilder
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Primary
import org.springframework.jdbc.core.JdbcTemplate
import javax.sql.DataSource


@Configuration
class DBConfig {
    @Primary
    @Bean("dbTestSource")
    @ConfigurationProperties("spring.datasource.test")
    fun dbTestProperties(): DataSource {
        return DruidDataSourceBuilder.create().build();
    }

    @Primary
    @Bean("dbTest")
    fun jdbcTemplateOne(@Qualifier("dbTestSource") dataSource: DataSource): JdbcTemplate {
        return JdbcTemplate(dataSource)
    }
}