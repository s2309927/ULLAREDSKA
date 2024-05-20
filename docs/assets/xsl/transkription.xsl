<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:html="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs tei html" version="2.0">
    <xsl:output method="html"/>

    <!-- transform the root element (TEI) into an HTML template -->
    <xsl:template match="tei:TEI">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text><xsl:text>&#xa;</xsl:text>
        <html lang="en" xml:lang="en">
            <head>
                <title>
                    <!-- add the title from the metadata. This is what will be shown
                    on your browsers tab-->
                    Projekt Ullaredska: Transkription
                </title>
                <!-- load bootstrap css (requires internet!) so you can use their pre-defined css classes to style your html -->
                <link rel="stylesheet"
                    href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
                    integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
                    crossorigin="anonymous"/>
                <!-- load the stylesheets in the assets/css folder, where you can modify the styling of your website -->
                <link rel="stylesheet" href="assets/css/main.css"/>
                <!-- add additional css to overrule the (generic) bootstrap stylesheet -->
                <style>
                    .bastext{
                    color: black;
                    }
                </style>
            </head>
            <body>
                <header>
                    <h1>
                        Projekt Ullaredska
                    </h1>
                </header>
                <nav id="sitenav"><a href="index.html">Om projektet</a> |
                    <a href="transkription.html">Transkription</a> |
                    <a href="dialektala.html">Dialektala ord</a> |
                    <a href="oversattning.html">Översättning</a> |
                    <a href="slatter.html">Slåtter</a>
                </nav>
                <main id="manuscript">
                    <!-- bootstrap "container" class makes the columns look pretty -->
                    <div class="container">
                        <!-- define a row layout with bootstrap's css classes (two columns) -->
                        <div class="row">
                            <div class="col-sm">
                                <h3>Bilder</h3>
                            </div>
                            <div class="col-sm">
                                <h3>Transkription</h3>
                            </div>
                        </div>
                        <!-- set up an image-text pair for each page in your document, and start a new 'row' for each pair -->
                        <xsl:for-each select="//tei:div[@type='page']">
                            <div class="row">
                                <!-- fill the first column with this page's image -->
                                <div class="col-sm">
                                    <article>
                                        <!-- make an HTML <img> element, with a maximum width of 400 pixels -->
                                        <img class="img-full" src="assets/img/documents/pic.jpg" title="" alt="">
                                        </img>
                                    </article>
                                </div>
                                <!-- fill the second column with our transcription -->
                                <div class='col-sm'>
                                    <article class="transcription">
                                        <xsl:apply-templates/>                                      
                                    </article>
                                </div>
                            </div>
                        </xsl:for-each>
                    </div>
                </main>
                <footer>
                <div class="row" id="footer">
                  <div class="col-sm copyright">
                      <div>
                          ©2024 Project DIFBOT: AnCa, ClaDe &amp; NiLe
                      </div>
                    </div>
                </div>
                </footer>
                <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
            </body>
        </html>
    </xsl:template>

    <!-- by default all text nodes are printed out, unless something else is defined.
    We don't want to show the metadata. So we write a template for the teiHeader that
    stops the text nodes underneath (=nested in) teiHeader from being printed into our
    html-->
    <xsl:template match="tei:teiHeader"/>

    <!-- turn tei line beginnings (lb) into html linebreaks (br) -->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <!-- note: in the previous template there is no <xsl:apply-templates/>. This is because there is nothing to
    process underneath (nested in) tei lb's. Therefore the XSLT processor does not need to look for templates to
    apply to the nodes nested within it.-->


    <!-- we turn the tei head element (headline) into an html h4 element-->
    <xsl:template match="tei:head">
        <h4>
            <xsl:apply-templates/>
        </h4>
    </xsl:template>

    <xsl:template match="tei:note">
        <span class="note">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- transform tei paragraphs into html paragraphs -->
    <xsl:template match="tei:p">
        <p class="bastext">
            <!-- apply matching templates for anything that was nested in tei:p -->
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    
    <!-- give all metamarks with a @place a class of the same name in the html-->
    <!-- out of the box, the css of this template has classes for 'top-left' and 'top-right' values for metamark[@place]. You can change them in `main.css` if you need to.-->
    <!-- if you want to use other values, be sure to also make corresponding class descriptions in your `main.css` stylesheet. -->
    <xsl:template match="tei:metamark[@place]">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="@place"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template> 
    
    <!-- in order to make signature italic, transform into class, then define in css -->
    <xsl:template match="tei:rs[@key='signature']">
        <span class="signature">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    


</xsl:stylesheet>
