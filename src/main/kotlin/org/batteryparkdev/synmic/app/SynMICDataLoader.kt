package org.batteryparkdev.synmic.app

import com.google.common.base.Stopwatch
import org.batteryparkdev.genomicgraphcore.common.formatNeo4jStringList
import org.batteryparkdev.genomicgraphcore.neo4j.service.Neo4jConnectionService
import java.util.concurrent.TimeUnit
import kotlin.system.exitProcess

/*
Kotlin application to load COSMIC and  SynMIC data files into local Neo4j database
 */

private val deleteOption = "DELETE"
private val graphDefinitionsFiles = listOf("./SynMICConstraints.cql",
    "./cql/synmicdb.cql")

private fun clearDatabase() {
    println("WARNING: You have elected to delete the entire contents of the Neo4j database !!!!")
    println("Please confirm your selection by entering: DELETE")
    println("Any other input will terminate the program")
    val choice = readLine()
    if (choice == deleteOption) {
        println("Deleting database contents")
        Neo4jConnectionService.executeCypherCommand("MATCH (n) DETACH DELETE(n)")
    } else {
        println("Program terminating ")
        exitProcess(0)
    }
}

private fun executeCqlScripts() {
    println("Initiating data loading")
    val stopwatch = Stopwatch.createStarted()
    Neo4jConnectionService.executeCypherCommand("CALL apoc.cypher.runFiles(${formatNeo4jStringList(graphDefinitionsFiles)})")
    println("Loading Neo4j database completed in ${stopwatch.elapsed(TimeUnit.MINUTES)} minutes.")
}

fun main(args: Array<String>) {
    if (args.isNotEmpty() && args[0] == deleteOption) {
        clearDatabase()
    }
    executeCqlScripts()
    println("FINIS....")
}