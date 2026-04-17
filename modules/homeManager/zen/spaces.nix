let
  containers = import ./containers.nix;
in {
  Personal = {
    id = "1f8a6f7c-3b59-4d65-9c1f-0a3e9a6f1b01";
    icon = "🏠";
    position = 1000;
    container = containers.personal.id;
  };

  Homelab = {
    id = "2b9d4c41-6a8e-4c9b-9a44-6d1c7f2e8b02";
    icon = "💻"; # Swapped to Laptop
    position = 2000;
    container = containers.homelab.id;
  };

  Work = {
    id = "3c7e2b6d-9f5a-4b41-8f77-1e9c5a4d2c03";
    icon = "💼"; # Briefcase
    position = 3000;
    container = containers.work.id;
  };

  School = {
    id = "4d8f3c7e-0a6b-5c52-9e88-2f0d6b5e3d14";
    icon = "🎓"; # Graduation Cap
    position = 4000;
    container = containers.school.id;
  };

  Shopping = {
    id = "5e9a4d8f-1b7c-6d63-af99-3f1e7c6f4e25";
    icon = "🛒"; # Shopping Cart
    position = 5000;
    container = containers.shopping.id;
  };

  Banking = {
    id = "6f0b5e9a-2c8d-7e74-bf0a-4f2f8d7a5f36";
    icon = "🏦"; # Bank Building
    position = 6000;
    container = containers.banking.id;
  };
}
