using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InvestmentScore.DataRefresh;
using System.Data.SqlClient;
using System.Data;
using log4net;
using log4net.Config;
using System.Security.Authentication;

namespace InvestmentScore.DataRefresh
{
    class InvestmentScoreHelper
    {
        private static ILog logger = LogManager.GetLogger("DataSync");
        public static bool CopyData()
        {
            string connectionString = ConfigurationManager.AppSettings["sourceConnection"];

            string destinationConnectionString = ConfigurationManager.AppSettings["destinationConnection"];
            log4net.Config.XmlConfigurator.Configure();
            logger.Info("Starting data sync...");

            int numErr = Int32.Parse(ConfigurationManager.AppSettings["numErrorTest"]);
            int maxRetries = Int32.Parse(ConfigurationManager.AppSettings["Retry"]);
            int delay = Int32.Parse(ConfigurationManager.AppSettings["delay"]);
            int numTries = 1;
            bool succeeded = false;

            while (numTries <= maxRetries)
            {
                try
                {
                    // Open a sourceConnection to the AdventureWorks database.
                    using (SqlConnection sourceConnection =
                               new SqlConnection(connectionString))
                    {
                        logger.Info("Opening connection to data source");

                        sourceConnection.Open();
                        SqlCommand commandRowCount = new SqlCommand(
                        @"Select count(*) from [FinancialDashboard].[toolkit].[vInvestmentPaymentByStrategyCurrent]
                WHERE [INV Source] <> 'Gateway'
                    and [INV ID] IS NOT NULL
                    and [PMT Expenditure Type] = 'DCE' 
                    /*Exclude Pre-published INVEST*/
                    AND 
                        (
                            CASE WHEN 
                                [INV Source] = 'IMS' AND ISNULL([CPT Workflow Step],'') = 'Pre-proposal Development' THEN 0
                            WHEN 
                                [INV Source] = 'IMS' AND [INV Type] = 'Contract' AND ISNULL([CPT Workflow Step],'') = 'Investment Development' THEN 0
                            ELSE
                                1
                            END
                        ) = 1
"
                        , sourceConnection);


                        long countStart = System.Convert.ToInt32(commandRowCount.ExecuteScalar());
                        logger.Info(string.Format("Starting row count = {0}", countStart));

                        logger.Info("Executing data retrieval");
                        // Get data from the source table as a SqlDataReader.
                        SqlCommand commandSourceData = new SqlCommand(
                            @"SELECT 
					   [CPT_Gateway_ID] = ISNULL(i.[CPT Gateway ID],'')
                      ,[CPT_Is_A_Supplement_Flag] =  ISNULL(i.[CPT Is A Supplement Flag],'')
                      ,[CPT_Overall_Decision_1_Date] =  ISNULL(i.[CPT Overall Decision 1 Date],'')
                      ,[CPT_Overall_Decision_1_Result]= i.[CPT Overall Decision 1 Result]
                      ,[CPT_Overall_Decision_1A_Date]=  ISNULL(i.[CPT Overall Decision 1A Date],'')
                      ,[CPT_Overall_Decision_1A_Result]= i.[CPT Overall Decision 1A Result]
                      ,[CPT_Overall_Decision_1B_Date]= ISNULL(i.[CPT Overall Decision 1B Date],'')
                      ,[CPT_Overall_Decision_1B_Result]= i.[CPT Overall Decision 1B Result]
                      ,[CPT_Overall_Decision_2_Date]=  ISNULL(i.[CPT Overall Decision 2 Date],'')
                      ,[CPT_Overall_Decision_2_Result]= i.[CPT Overall Decision 2 Result]
                      ,[CPT_Relationship_Manager]= i.[CPT Relationship Manager]
                      ,[INV_Approval_Probability]= i.[INV Approval Probability]
                      ,[INV_Description] = gc.[OPP Public Description]
                      ,[INV_End_Date]= i.[INV End Date]
                      ,[INV_Forecasted_Approval_Committed_Date] = i.[INV Forecasted Approval/Committed Date]
                      ,[INV_Gate_3_Invest_Approval_Date] = i.[INV Gate 3 (Invest) Approval Date]
                      ,[INV_Grantee_Vendor_Name] =i.[INV Grantee/Vendor Name]
                      ,[INV_ID]= i.[INV COMBINED ID]
                      ,[INV_Level_Of_Engagement]= i.[INV Level Of Engagement]
                      ,[INV_Manager]= i.[INV Manager]
                      ,[INV_Managing_SubTeam]= i.[INV Managing Sub-Team]
                      ,[INV_Managing_Team_Level_3] = i.[INV Managing Team Level 3]
                      ,[INV_Managing_Team_Level_4] = i.[INV Managing Team Level 4]
                      ,[INV_Managing_Team_Path] = i.[INV Managing Team Path]
                      ,[INV_Managing_Team] = i.[INV Managing Team]
                      ,[INV_Owner] = i.[INV Owner]
                      ,[INV Source] = i.[INV Source]
                      ,[INV_Start_Date] = i.[INV Start Date]
                      ,[INV_Status] = i.[INV Status]
                      ,[INV_Title]= i.[INV Title]
                      ,[INV_Total_Payout_Amt] = CAST(i.[INV Total Payout Amt] as DECIMAL(18,2)) 
                      ,[INV_Type] = i.[INV Type]
                      ,[PMT_Dashboard_Payout_Category_Rollup] =i.[PMT Dashboard Payout Category]
                      ,[PMT_Dashboard_Payout_Category]= i.[PMT Dashboard Payout Category Rollup]
                      ,[PMT_Division]= i.[PMT Division]
                      ,[PMT_Expenditure_Type]= i.[PMT Expenditure Type]
                      ,[PMT_Initiative]= i.[PMT Initiative]
                      ,[PMT_Key_Element]= i.[PMT Key Element]
                      ,[PMT_Pay_Date_Half_Year]= i.[PMT Pay Date Half Year]
                      ,[PMT_Pay_Date_Month]= i.[PMT Pay Date Month]
                      ,[PMT_Pay_Date_Quarter]= i.[PMT Pay Date Quarter]
                      ,[PMT_Pay_Date]=i.[PMT Pay Date]
                      ,[PMT_Pay_Year]=i.[PMT Pay Year]
                      ,[PMT_Payment_ID]=i.[PMT Payment ID]
                      ,[PMT_Payout_Category_Rollup]=i.[PMT Payout Category Rollup]
                      ,[PMT_Payout_Category]=i.[PMT Payout Category]
                      ,[PMT_Payout_Sub_Category]=i.[PMT Payout Sub Category]
                      ,[PMT_Status]=i.[PMT Status]
                      ,[PMT_Strategy_Allocation_Amt]= CAST(i.[PMT Strategy Allocation Amt] as DECIMAL(18,2))
                      ,[PMT_Strategy]=i.[PMT Strategy]
                      ,[PMT_SubInitiative]=i.[PMT Sub-Initiative]
                      ,[PMT_Total_Pay_Amt]=CAST(i.[PMT Total Pay Amt] as DECIMAL(18,2))
                      ,[PMT_Type]=i.[PMT Type]
                      ,[SYS_INV_URL]=i.[SYS INV URL] 
					  ,[OPP_Closed_Date] = gc.[OPP Closed Date] 
                  FROM [FinancialDashboard].[toolkit].[vInvestmentPaymentByStrategyCurrent] i
				  LEFT JOIN (  SELECT 
								  [OPP Opportunity ID]
								  ,[OPP Public Description]
								  ,[OPP Closed Date]     
							  FROM [FinancialDashboard].[toolkit].[vGrantCurrent]
							  WHERE [OPP Opportunity ID]  is not null
							  AND ([OPP Source] = 'Unison'
									OR ([OPP Source] = 'IMS' AND ISNULL([CPT Workflow Step],'') <> 'Pre-proposal Development')) --Include Published Grants ONLY
							  GROUP BY 		 [OPP Opportunity ID],
								  [OPP Public Description] 
								  ,[OPP Closed Date]			    
							) gc 
					ON gc.[OPP Opportunity ID] = i.[INV COMBINED ID]
					WHERE i.[INV Source] <> 'Gateway'
					AND i.[INV ID] IS NOT NULL
					AND i.[PMT Expenditure Type] = 'DCE'
                    /*Exclude Pre-published INVEST*/
                    AND 
                        (
                            CASE WHEN 
                                i.[INV Source] = 'IMS' AND ISNULL(i.[CPT Workflow Step],'') = 'Pre-proposal Development' THEN 0
                            WHEN 
                                i.[INV Source] = 'IMS' AND i.[INV Type] = 'Contract' AND ISNULL(i.[CPT Workflow Step],'') = 'Investment Development' THEN 0
                            ELSE
                                1
                            END
                        ) = 1
                    ", sourceConnection);

                        SqlDataReader reader = commandSourceData.ExecuteReader();

                        using (SqlConnection destinationConnection = new SqlConnection(destinationConnectionString))
                        {
                            logger.Info("Opening connection to data destination");
                            destinationConnection.Open();

                            logger.Info("Truncating data table");
                            SqlCommand truncateCommand = new SqlCommand("truncate table [dbo].[Investment_Payment]", destinationConnection);
                            truncateCommand.ExecuteNonQuery();

                            using (SqlBulkCopy bulkcopy = new SqlBulkCopy(destinationConnection))
                            {
                                //This is to throw exception intentional for testing
                                //The condition is just to throw exception in different line
                                while (numErr != 0 && numErr > 0 && numErr != 2)
                                {
                                    throw new AuthenticationException("Custom Exception");
                                }

                                logger.Info("Starting bulk copy");

                                //This is to throw exception intentional for testing
                                //The condition is just to throw exception in different line to test if exception could be catch elsewhere
                                if (numErr == 2)
                                    throw new AuthenticationException("Custom Exception");
                                bulkcopy.DestinationTableName =
                                    "dbo.Investment_Payment";
                                bulkcopy.BatchSize = 1000;
                                bulkcopy.WriteToServer(reader);

                                logger.Info("Executing investment data refresh");
                                SqlCommand refreshInvestmentData = new SqlCommand("execute [dbo].[usp_RefreshInvestmentData]", destinationConnection);
                                refreshInvestmentData.CommandTimeout = 300;
                                refreshInvestmentData.ExecuteNonQuery();

                                succeeded = true;

                                if (succeeded)
                                {
                                    reader.Close();
                                    logger.Info("Execution complete");
                                    break;
                                }
                            }
                        }
                    }

                }
                catch (Exception ex)
                {
                    logger.Fatal(numTries + " attempt/s failed: " + ex.Message);
                    Console.Write("\n");
                }
                finally
                {
                    numTries++;
                    numErr--;
                }
                if (numTries > maxRetries && !succeeded)
                {
                    logger.Info("Execution Failed!");
                }
                System.Threading.Thread.Sleep(delay);
            }

            return true;
        }
    }
}
