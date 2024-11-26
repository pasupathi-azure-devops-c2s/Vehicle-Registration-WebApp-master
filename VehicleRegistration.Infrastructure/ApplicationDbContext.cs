using Microsoft.EntityFrameworkCore;
using VehicleRegistration.Infrastructure.DataBaseModels;

namespace VehicleRegistration.Infrastructure
{
    public class ApplicationDbContext : DbContext
    {
        public virtual DbSet<UserModel> Users { get; set; }
        public virtual DbSet<VehicleModel> VehiclesDetails { get; set; }
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }
        //protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        //{
        //    optionsBuilder.UseSqlServer("Data Source=.;Initial Catalog=VehicleRegistrationApp;Integrated Security=True;Connect Timeout=30;Encrypt=False;Trust Server Certificate=True;");
        //}
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<UserModel>().HasKey(u => u.UserId);
            modelBuilder.Entity<VehicleModel>().HasKey(v => v.VehicleId);
            modelBuilder.Entity<VehicleModel>().HasOne(u => u.User).WithMany(v => v.Vehicles).HasForeignKey(i => i.UserId);
            modelBuilder.Entity<VehicleModel>().Property(c => c.OwnerContactNumber).HasMaxLength(15);
        }
    }
}