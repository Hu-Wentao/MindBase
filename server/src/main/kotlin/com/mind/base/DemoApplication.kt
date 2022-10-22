package com.mind.base

import org.springframework.boot.autoconfigure.EnableAutoConfiguration
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication(scanBasePackages= ["com.mind.base"])
class MindBaseApplication

fun main(args: Array<String>) {
	runApplication<MindBaseApplication>(*args)
}
