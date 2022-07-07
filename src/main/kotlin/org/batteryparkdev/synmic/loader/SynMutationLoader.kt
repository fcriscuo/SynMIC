package org.batteryparkdev.synmic.loader

import com.google.common.base.Stopwatch
import com.google.common.flogger.FluentLogger
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.ReceiveChannel
import kotlinx.coroutines.channels.produce
import kotlinx.coroutines.delay
import kotlinx.coroutines.runBlocking
import org.batteryparkdev.cosmicgraphdb.model.CosmicModel
import org.batteryparkdev.io.CSVRecordSupplier
import org.batteryparkdev.neo4j.service.Neo4jConnectionService
import org.batteryparkdev.synmic.model.SynMutation
import java.nio.file.Paths
import java.util.concurrent.TimeUnit
import kotlin.streams.asSequence

/*
Responsible for reading the SynMICdb.csv file, parsing its records into SynMutation
model objects, and loading these data into the CosmicGraph Neo4j database.
Input is the complete path to rhe SynMICdb.csv file
 */
class SynMutationLoader (val filename: String) {

    private val logger: FluentLogger = FluentLogger.forEnclosingClass()

    @OptIn(ExperimentalCoroutinesApi::class)
    private fun CoroutineScope.csvProcessCosmicFile() =
        produce<CosmicModel> {
            val path = Paths.get(filename)
            CSVRecordSupplier(path).get().asSequence()
                .map { SynMutation.parseCSVRecord(it) }
                .forEach {
                    if (it.isValid()) {
                        (send(it))
                    }
                    delay(20L)
                }
        }

    /*
  Private function to load the CosmicModel into the Neo4j database
   */
    @OptIn(ExperimentalCoroutinesApi::class)
    private fun CoroutineScope.loadCosmicModel(models: ReceiveChannel<CosmicModel>) =
        produce<CosmicModel> {
            for (model in models){
                Neo4jConnectionService.executeCypherCommand(model.generateLoadCosmicModelCypher())
                send(model)
                delay(20L)
            }
        }

    /*
   Function to load data from the csv file into the Neo4j database
    */
    fun loadCosmicFile() = runBlocking {
        logger.atInfo().log("Loading Synonymous Mutation  data from file: $filename")
        var nodeCount = 0
        val stopwatch = Stopwatch.createStarted()
        val models = loadCosmicModel(csvProcessCosmicFile())
        for ( model in models){
            nodeCount += 1
            println("Loaded ${model.getNodeIdentifier().primaryLabel}  id: ${model.getNodeIdentifier().idValue}")
        }
        logger.atInfo().log(
            " data from file: $filename loaded " +
                    " $nodeCount nodes in " +
                    " ${stopwatch.elapsed(TimeUnit.SECONDS)} seconds")
    }
}

fun main (args: Array<String>){
    val filename = if (args.isNotEmpty()) args[0]  else "./data/sample_SynMICdb.csv"
    val database = System.getenv("NEO4J_DATABASE")
    println("Loading Synonymous Mutation data from $filename to $database Neo4j database")
    SynMutationLoader(filename).loadCosmicFile()
}