using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;

namespace Scheduler.Helpers
{
    public class Constants
    {
        //Status
        public const int Draft = 1000;
        public const int SubmittedforReview = 1001;
        public const int Declined = 1003;
        public const int Approved = 1004;
        public const int Scheduled = 1006;
        public const int Completed = 1007;
        public const int Opportunistic = 1008;

        //Purpose
        public const int StrategyReview = 1000;
        public const int ProgressReview = 1001;
        public const int StrategyDevelopment = 1002;
        public const int Learning = 1003;
        public const int AdvocacyOutreachCalls = 1004;
        public const int TripEventPretripSpeechPrep = 1005;
        public const int BookOfBusiness = 1006;
        public const int GlobalGood = 1007;

        public const string LEADURL = "http://lead/";

        //SysUser Type Id from SysUserType table coming from database
        public const int CommunicationsLead = 1003;
        public const int ContentOwner = 1001;
        public const int SpeechWriter = 1004;
        public const int Staff = 1000;
        public const int TripDirector = 1002;

        //Required Status and Purpose coming from web config
        public static int[] RequiredStatusId = Array.ConvertAll(ConfigurationManager.AppSettings["RequiredEngagementStatus"].Split(new[] { ";" }, StringSplitOptions.None), int.Parse);
        public static int[] RequiredPurposeId = Array.ConvertAll(ConfigurationManager.AppSettings["RequiredEngagementPurpose"].Split(new[] { ";" }, StringSplitOptions.None), int.Parse);

    }
}