//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ODMS.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class tbld_distribution_house
    {
        public int DB_Id { get; set; }
        public string DBName { get; set; }
        public string DBCode { get; set; }
        public string DBDescription { get; set; }
        public string OfficeAddress { get; set; }
        public string WarehouseAddress { get; set; }
        public string OwnerName { get; set; }
        public string OwnerMoble { get; set; }
        public string EmailAddress { get; set; }
        public Nullable<System.DateTime> CreateDate { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public int Cluster_id { get; set; }
        public int Zone_id { get; set; }
        public int PriceBuandle_id { get; set; }
        public int DeliveryModuleStatus { get; set; }
        public int Status { get; set; }
    }
}