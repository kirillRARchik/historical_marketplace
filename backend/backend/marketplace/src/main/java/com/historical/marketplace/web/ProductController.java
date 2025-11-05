package com.historical.marketplace.web;

import com.historical.marketplace.model.Product;
import com.historical.marketplace.model.SellerProfile;
import com.historical.marketplace.repo.ProductRepository;
import com.historical.marketplace.repo.SellerProfileRepository;
import com.historical.marketplace.repo.UserRepository;
import com.historical.marketplace.service.PhotoStorageService;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/products")
public class ProductController {
    private final ProductRepository productRepository;
    private final SellerProfileRepository sellerProfileRepository;
    private final UserRepository userRepository;
    private final PhotoStorageService photoStorageService;

    public ProductController(ProductRepository productRepository, SellerProfileRepository sellerProfileRepository, UserRepository userRepository, PhotoStorageService photoStorageService) {
        this.productRepository = productRepository;
        this.sellerProfileRepository = sellerProfileRepository;
        this.userRepository = userRepository;
        this.photoStorageService = photoStorageService;
    }

    public record ProductRequest(String photoUrl,
                                 @NotBlank String name,
                                 @NotNull Double price,
                                 @NotNull Integer quantity,
                                 @NotNull Boolean customMade,
                                 String sizeMeasure,
                                 String manufacturingMethod,
                                 String category,
                                 String authenticityCertificate,
                                 String period,
                                 String material) {}

    public record SearchRequest(String query, String category, Double minPrice, Double maxPrice, Boolean customMade) {}

    @GetMapping
    public List<Product> listAll() { return productRepository.findAll(); }

    @GetMapping("/category/{category}")
    public List<Product> listByCategory(@PathVariable String category) {
        return productRepository.findByCategory(category);
    }

    @GetMapping("/search")
    public ResponseEntity<?> searchProducts(@RequestParam(required = false) String query,
                                           @RequestParam(required = false) String category,
                                           @RequestParam(required = false) Double minPrice,
                                           @RequestParam(required = false) Double maxPrice,
                                           @RequestParam(required = false) Boolean customMade) {
        if (query != null && !query.isEmpty()) {
            List<Product> results = productRepository.searchProducts(query);
            if (category != null || minPrice != null || maxPrice != null || customMade != null) {
                results = results.stream()
                        .filter(p -> category == null || category.equals(p.getCategory()))
                        .filter(p -> minPrice == null || p.getPrice() >= minPrice)
                        .filter(p -> maxPrice == null || p.getPrice() <= maxPrice)
                        .filter(p -> customMade == null || p.getCustomMade() == customMade)
                        .toList();
            }
            return ResponseEntity.ok(Map.of("results", results, "count", results.size()));
        } else {
            List<Product> results = productRepository.searchWithFilters(category, minPrice, maxPrice, customMade);
            return ResponseEntity.ok(Map.of("results", results, "count", results.size()));
        }
    }

    @PostMapping("/upload-photo")
    public ResponseEntity<?> uploadPhoto(org.springframework.security.core.Authentication auth,
                                         @org.springframework.web.bind.annotation.RequestPart("file") org.springframework.web.multipart.MultipartFile file) {
        var user = userRepository.findByEmail(auth.getName()).orElse(null);
        if (user == null) return ResponseEntity.status(401).build();
        var seller = sellerProfileRepository.findByUserId(user.getId()).orElse(null);
        if (seller == null) return ResponseEntity.status(403).body(Map.of("error", "Not a seller"));
        try {
            String url = photoStorageService.store(file);
            return ResponseEntity.ok(Map.of("url", url));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping
    public ResponseEntity<?> create(Authentication auth, @RequestBody ProductRequest req) {
        var user = userRepository.findByEmail(auth.getName()).orElse(null);
        if (user == null) return ResponseEntity.status(401).build();
        SellerProfile sp = sellerProfileRepository.findByUserId(user.getId()).orElse(null);
        if (sp == null) return ResponseEntity.status(403).body(Map.of("error", "Not a seller"));
        Product p = new Product();
        p.setSeller(sp);
        p.setPhotoUrl(req.photoUrl());
        p.setName(req.name());
        p.setPrice(req.price());
        p.setQuantity(req.quantity());
        p.setCustomMade(req.customMade());
        p.setSizeMeasure(req.sizeMeasure());
        p.setManufacturingMethod(req.manufacturingMethod());
        p.setCategory(req.category());
        p.setAuthenticityCertificate(req.authenticityCertificate());
        p.setPeriod(req.period());
        p.setMaterial(req.material());
        productRepository.save(p);
        return ResponseEntity.ok(p);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(Authentication auth, @PathVariable Long id, @RequestBody ProductRequest req) {
        var user = userRepository.findByEmail(auth.getName()).orElse(null);
        if (user == null) return ResponseEntity.status(401).build();
        var product = productRepository.findById(id).orElse(null);
        if (product == null) return ResponseEntity.notFound().build();
        if (!product.getSeller().getUser().getId().equals(user.getId()))
            return ResponseEntity.status(403).body(Map.of("error", "Not owner"));
        product.setPhotoUrl(req.photoUrl());
        product.setName(req.name());
        product.setPrice(req.price());
        product.setQuantity(req.quantity());
        product.setCustomMade(req.customMade());
        product.setSizeMeasure(req.sizeMeasure());
        product.setManufacturingMethod(req.manufacturingMethod());
        product.setCategory(req.category());
        product.setAuthenticityCertificate(req.authenticityCertificate());
        product.setPeriod(req.period());
        product.setMaterial(req.material());
        productRepository.save(product);
        return ResponseEntity.ok(product);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(Authentication auth, @PathVariable Long id) {
        var user = userRepository.findByEmail(auth.getName()).orElse(null);
        if (user == null) return ResponseEntity.status(401).build();
        var product = productRepository.findById(id).orElse(null);
        if (product == null) return ResponseEntity.notFound().build();
        if (!product.getSeller().getUser().getId().equals(user.getId()))
            return ResponseEntity.status(403).body(Map.of("error", "Not owner"));
        productRepository.delete(product);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{id}/verify")
    public ResponseEntity<?> verifyProduct(Authentication auth, @PathVariable Long id, @RequestBody Map<String, Boolean> body) {
        var user = userRepository.findByEmail(auth.getName()).orElse(null);
        if (user == null) return ResponseEntity.status(401).build();

        // Check if user is admin
        if (!user.getRoles().contains("ADMIN")) {
            return ResponseEntity.status(403).body(Map.of("error", "Admin only"));
        }

        var product = productRepository.findById(id).orElse(null);
        if (product == null) return ResponseEntity.notFound().build();

        product.setVerifiedByAdmin(body.get("verified"));
        productRepository.save(product);
        return ResponseEntity.ok(product);
    }
}


