package org.batteryparkdev.synmic.loader

import org.batteryparkdev.genomicgraphcore.common.CoreModelLoader
import org.batteryparkdev.synmic.dao.SynMutationDao
import org.batteryparkdev.synmic.model.SynMutation

fun main(args: Array<String>){
    val filename = if (args.isNotEmpty()) args[0] else "./data/sample_SynMICdb.csv"
    CoreModelLoader(SynMutation, SynMutationDao).loadDataFile(filename)
}
