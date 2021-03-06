library(shiny)
library(r4ss)
library(ggplot2)
shinyServer(function(input, output) {

    calc <- reactive({
        n <- as.numeric(input$n)
        N <- as.numeric(input$N)
        CI <- as.numeric(input$CI)
        p <- as.numeric(input$p)

        df <- data.frame(matrix(nrow=N,ncol=6))
        colnames(df) <- c("hits","pHat","pSD","pHatMax","pHatMin","no.sample")
        
        for (i in 1:N){
            x <- rbinom(n,size=1,prob=p)
            pHat <- mean(x)
            pSD <- sqrt(pHat*(1-pHat)/n)
            CI.corrected <- ((100-CI)/2+CI)/100
            q <- qnorm(CI.corrected)
            pHatMax <- (pHat+q*pSD)
            pHatMin <- (pHat-q*pSD)
            hits <- pHatMax>p && pHatMin<p
            df[i,] <- list(hits,pHat,pSD,pHatMax,pHatMin,i)
           
        }
        df
    })

    hits <- reactive({
        df <- calc()
        sum(df[,1])/nrow(df)*100
        
    })
        

    output$hits <- renderText(paste("Actual Percentage of number of samples containing population probability within their confidence bands of ",as.numeric(input$CI),"% is =",round(hits(),digits=2)))

    output$plot1 <- renderPlot({
        df <- calc()
        df$hits <- as.factor(df$hits)
        df$hits <- relevel(df$hits,"TRUE")
        ggplot(df, aes(x=no.sample, y=pHat, colour=hits)) +
        geom_errorbar(aes(ymin=pHatMin, ymax=pHatMax), width=1) +
        geom_hline(yintercept=as.numeric(input$p), linetype="dashed",
        color = "red",
        size=2)+scale_color_manual(breaks=c("TRUE","FALSE"),values=c("green","red"))+
            coord_flip() 
        
    })


    output$plot2  <-
        renderText("The X axis denotes the sample probability, and the y axis denotes the number of samples (N). The red vertical line is the population probability. Green confidence bands contain the population probability. Red confidence bands are NOT containing the population probability.")
    
    output$docu <-
        renderText("Change the sliders to see the change in the plots. The above plots inform if it is a reasonable approximation to take the SE (standard error) of the sample as a ssubstitute for the population standard deviation.")

    output$docu2 <- renderText("We compute the number of times a 'mean of a random sample' is within 'X' Standard errors of population probability. This number is shown above the plot and is very close to the Confidence interval.")

    output$insp <- renderText("https://www.khanacademy.org/math/ap-
statistics/estimating-confidence-ap/introduction-confidence-intervals/
v/confidence-interval-simulation")

    output$code <-
        renderText("The Code and calculations are shown in presentation of this assignment.")

    

})
