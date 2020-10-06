datacache <- new.env(hash=TRUE, parent=emptyenv())

org.Elanceolatus.eg <- function() showQCData("org.Elanceolatus.eg", datacache)
org.Elanceolatus.eg_dbconn <- function() dbconn(datacache)
org.Elanceolatus.eg_dbfile <- function() dbfile(datacache)
org.Elanceolatus.eg_dbschema <- function(file="", show.indices=FALSE) dbschema(datacache, file=file, show.indices=show.indices)
org.Elanceolatus.eg_dbInfo <- function() dbInfo(datacache)

org.Elanceolatus.egORGANISM <- "Epinephelus lanceolatus"

.onLoad <- function(libname, pkgname)
{
    ## Connect to the SQLite DB
    dbfile <- system.file("extdata", "org.Elanceolatus.eg.sqlite", package=pkgname, lib.loc=libname)
    assign("dbfile", dbfile, envir=datacache)
    dbconn <- dbFileConnect(dbfile)
    assign("dbconn", dbconn, envir=datacache)

    ## Create the OrgDb object
    sPkgname <- sub(".db$","",pkgname)
    db <- loadDb(system.file("extdata", paste(sPkgname,
      ".sqlite",sep=""), package=pkgname, lib.loc=libname),
                   packageName=pkgname)    
    dbNewname <- AnnotationDbi:::dbObjectName(pkgname,"OrgDb")
    ns <- asNamespace(pkgname)
    assign(dbNewname, db, envir=ns)
    namespaceExport(ns, dbNewname)
        
    packageStartupMessage(AnnotationDbi:::annoStartupMessages("org.Elanceolatus.eg.db"))
}

.onUnload <- function(libpath)
{
    dbFileDisconnect(org.Elanceolatus.eg_dbconn())
}

